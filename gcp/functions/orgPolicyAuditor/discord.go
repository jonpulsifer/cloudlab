package cloudfunction

import (
	"encoding/binary"
	"fmt"
	"io"
	"os"
	"strings"
	"time"

	"github.com/bwmarrin/discordgo"
	log "github.com/sirupsen/logrus"
)

// DefaultTextChannel = is discord a siem
const DefaultTextChannel = "670739595129782272"

// DefaultVoiceChannel = gone phishin
const DefaultVoiceChannel = "670739244817317930"

var buffer = make([][]byte, 0)

// OpenDiscordSession opens a discord session lol
func OpenDiscordSession() *discordgo.Session {
	token := os.Getenv("DISCORD_TOKEN")
	if token == "" {
		log.Fatalln("RIP, no token found. Set DISCORD_TOKEN")
	}

	// Load the sound file.
	err := loadSound()
	if err != nil {
		log.Fatalf("Error loading sound: %v", err)
	}

	// Create a new Discord session using the provided bot token.
	dg, err := discordgo.New("Bot " + token)
	if err != nil {
		log.Fatalf("Error creating Discord session: %v", err)
	}

	// Register ready as a callback for the ready events.
	dg.AddHandler(ready)

	// Open the websocket and begin listening.
	err = dg.Open()
	if err != nil {
		log.Fatalf("Error opening Discord session: %v", err)
	}

	// TODO: send a message

	// Wait here until CTRL-C or other term signal is received.
	// fmt.Println("Bot is now running.  Press CTRL-C to exit.")
	// sc := make(chan os.Signal, 1)
	// signal.Notify(sc, syscall.SIGINT, syscall.SIGTERM, os.Interrupt, os.Kill)
	// <-sc

	// Cleanly close down the Discord session.
	// dg.Close()
	return dg
}

func ready(s *discordgo.Session, event *discordgo.Ready) {
	s.UpdateStatus(0, ":cloud:")
}

// This function will be called (due to AddHandler above) every time a new
// message is created on any channel that the autenticated bot has access to.
func messageCreate(s *discordgo.Session, m *discordgo.MessageCreate) {

	// Ignore all messages created by the bot itself
	// This isn't required in this specific example but it's a good practice.
	if m.Author.ID == s.State.User.ID {
		return
	}

	// check if the message is "!alert"
	if strings.HasPrefix(m.Content, "!alert") {

		// Find the channel that the message came from.
		c, err := s.State.Channel(m.ChannelID)
		if err != nil {
			// Could not find channel.
			return
		}

		// Find the guild for that channel.
		g, err := s.State.Guild(c.GuildID)
		if err != nil {
			// Could not find guild.
			return
		}

		// Look for the message sender in that guild's current voice states.
		for _, vs := range g.VoiceStates {
			if vs.UserID == m.Author.ID {
				err = playSound(s, g.ID, vs.ChannelID)
				if err != nil {
					fmt.Println("Error playing sound:", err)
				}

				return
			}
		}
	}
}

// loadSound attempts to load an encoded sound file from disk.
func loadSound() error {

	file, err := os.Open("alert.dca")
	if err != nil {
		fmt.Println("Error opening dca file :", err)
		return err
	}

	var opuslen int16

	for {
		// Read opus frame length from dca file.
		err = binary.Read(file, binary.LittleEndian, &opuslen)

		// If this is the end of the file, just return.
		if err == io.EOF || err == io.ErrUnexpectedEOF {
			err := file.Close()
			if err != nil {
				return err
			}
			return nil
		}

		if err != nil {
			fmt.Println("Error reading from dca file :", err)
			return err
		}

		// Read encoded pcm from dca file.
		InBuf := make([]byte, opuslen)
		err = binary.Read(file, binary.LittleEndian, &InBuf)

		// Should not be any end of file errors
		if err != nil {
			fmt.Println("Error reading from dca file :", err)
			return err
		}

		// Append encoded pcm data to the buffer.
		buffer = append(buffer, InBuf)
	}
}

// playSound plays the current buffer to the provided channel.
func playSound(s *discordgo.Session, guildID, channelID string) (err error) {

	// Join the provided voice channel.
	vc, err := s.ChannelVoiceJoin(guildID, channelID, false, true)
	if err != nil {
		return err
	}

	// Sleep for a specified amount of time before playing the sound
	time.Sleep(250 * time.Millisecond)

	// Start speaking.
	vc.Speaking(true)

	// Send the buffer data.
	for _, buff := range buffer {
		vc.OpusSend <- buff
	}

	// Stop speaking
	vc.Speaking(false)

	// Sleep for a specificed amount of time before ending.
	time.Sleep(250 * time.Millisecond)

	// Disconnect from the provided voice channel.
	vc.Disconnect()

	return nil
}

func createAlertFromLog(l *AuditLog, s *discordgo.Session) *discordgo.MessageEmbed {
	var fields []*discordgo.MessageEmbedField

	fields = append(fields, &discordgo.MessageEmbedField{
		Name:   "API Details",
		Value:  fmt.Sprintf("**Service**: `%s`\n**Resource**: `%s`", l.ServiceName, l.ResourceName),
		Inline: true,
	})

	fields = append(fields, &discordgo.MessageEmbedField{
		Name:   "User",
		Value:  fmt.Sprintf("**Email**: `%s`", l.AuthenticationInfo.PrincipalEmail),
		Inline: true,
	})

	for d := range l.ServiceData.PolicyDelta.BindingDeltas {
		field := &discordgo.MessageEmbedField{
			Name:   fmt.Sprintf("%s Binding", strings.Title(strings.ToLower(l.ServiceData.PolicyDelta.BindingDeltas[d].Action))),
			Value:  fmt.Sprintf("**Member**: `%s`\n**Role**: `%s`", l.ServiceData.PolicyDelta.BindingDeltas[d].Member, l.ServiceData.PolicyDelta.BindingDeltas[d].Role),
			Inline: false,
		}
		fields = append(fields, field)
	}
	var m = discordgo.MessageEmbed{
		Title: "Org IAM Policy Changed!",
		Color: 0xcc0000, // Dark(er) Red
		Author: &discordgo.MessageEmbedAuthor{
			Name:    fmt.Sprintf("%s", s.State.User.Username),
			URL:     "https://github.com/jonpulsifer/cloudlab/tree/master/gcp/functions/go/iam-revoker",
			IconURL: "https://cdn.discordapp.com/avatars/679083916476284931/5eb8279f6ab340b685442c2ada5ac0cb.png?size=128",
		},
		Description: "This alert is triggered by any write operation on the [Organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization) resource. Any organization IAM policy change will trigger this function.",
		Fields:      fields,
		Thumbnail: &discordgo.MessageEmbedThumbnail{
			URL: "https://kstatic.googleusercontent.com/files/0b4c3e9c05e13e24ec9d5503d67ddac46fb8acce20e580e39a159379265879205d203dfcc71b857ac402241213d60914ef529f59b36785fbdd6ff9c7f1338470",
		},
		Footer: &discordgo.MessageEmbedFooter{
			Text:    "Powered by Google Cloud Functions",
			IconURL: "https://codelabs.developers.google.com/codelabs/cloud-starting-cloudfunctions/img/51b03178ac54a85f.png",
		},
		Timestamp: time.Now().Format(time.RFC3339),
	}

	return &m
}
