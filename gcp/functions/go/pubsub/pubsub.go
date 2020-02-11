package pubsub

import (
	"cloud.google.com/go/logging"
	"context"
	"encoding/json"
	log "github.com/sirupsen/logrus"
	"google.golang.org/genproto/googleapis/cloud/audit"
)

// Message is the payload of a Pub/Sub event.
type Message struct {
	Data []byte `json:"data"`
}

func init() {
	log.SetLevel(log.InfoLevel)
}

// Loglog gets a pubsub message
func Loglog(ctx context.Context, m Message) error {
	log.Infof("Got message :D")
	var l logging.Entry
	var p audit.AuditLog
	error := json.Unmarshal(m.Data, &l)
	if error != nil {
		log.Println("JSON parse error when converting to LogEntry: ", error)
		return nil
	}
	log.Infoln("lol: ", l.Resource.String())

	b, err := json.Marshal(l.Payload)
	if err != nil {
		log.Println("JSON marshal failure: ", error)
		return nil
	}

	err = json.Unmarshal(b, &p)
	if err != nil {
		log.Println("JSON parse error when converting to AuditLog: ", error)
		return nil
	}
	log.Infoln("who: ", p.AuthenticationInfo.GetPrincipalEmail())

	return nil
}
