package cloudfunction

import (
	"context"
	"encoding/json"
	"errors"
	"strings"

	log "github.com/sirupsen/logrus"
)

// Resource is a MonitoredResource
type Resource struct {
	Type string `json:"type"`
}

func init() {
	log.SetLevel(log.DebugLevel)
	// log.SetFormatter(&log.JSONFormatter{})
}

// Loglog gets a pubsub message
func Loglog(ctx context.Context, m Message) error {
	l, err := parseLogEntry(m)
	if err != nil {
		log.Errorf("Could not get audit log from pubsub message: %v", err)
		return err
	}
	if l == nil {
		return errors.New("Missing audit log")
	}

	log.WithFields(log.Fields{
		"User":    l.AuthenticationInfo.PrincipalEmail,
		"Service": l.ServiceName,
		"Method":  l.MethodName,
		"Deltas":  l.ServiceData.PolicyDelta.BindingDeltas,
	}).Debugf("Parsed audit log")

	// open discord
	discord := OpenDiscordSession()
	defer discord.Close()

	// build and send a text alert
	alertMessage := createAlertFromLog(l, discord)
	discord.ChannelMessageSendEmbed(DefaultTextChannel, alertMessage)

	// TODO: build and send a voice alert
	// TODO: revert the changes with the policy deltas
	return nil
}

func parseLogEntry(m Message) (*AuditLog, error) {
	var l *LogEntry
	if err := json.Unmarshal(m.Data, &l); err != nil {
		log.Fatalf("LogEntry parse error: ", err)
		return nil, err
	}
	if l.Resource.Type == "organization" {
		log.WithFields(log.Fields{
			"logName": l.LogName,
		}).Debugf("Processing organization event")

		if strings.HasSuffix(l.LogName, "activity") {
			log.WithFields(log.Fields{
				"LogName": l.LogName,
				"User":    l.Payload.AuthenticationInfo.PrincipalEmail,
				"Service": l.Payload.ServiceName,
				"Method":  l.Payload.MethodName,
				"Granted": l.Payload.ServiceData.PolicyDelta.BindingDeltas,
			}).Debugf("Processing write activity")
			return &l.Payload, nil
		}
	}

	log.WithFields(log.Fields{
		"LogName": l.LogName,
	}).Debugf("Skipped")

	return nil, nil
}
