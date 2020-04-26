package cloudfunction

import (
	"context"

	log "github.com/sirupsen/logrus"
)

// Message is the payload of a Pub/Sub event.
// See https://cloud.google.com/functions/docs/calling/pubsub.
type Message struct {
	Data       []byte            `json:"data"`
	Attributes map[string]string `json:"attributes"`
}

// Glue represents the modeling of data from a pubsub message
type Glue struct {
	Email      string            `json:"email"`
	Attributes map[string]string `json:"attributes,omitempty"`
	Data       []byte            `json:"data,omitempty"`
}

func init() {
	log.SetLevel(log.InfoLevel)
	log.SetFormatter(&log.JSONFormatter{})
}

// PubSubber gets a pubsub message and posts a discord message
func PubSubber(ctx context.Context, m Message) error {
	log.WithFields(log.Fields{
		"Email":      m.Attributes["email"],
		"Attributes": m.Attributes,
		"Data":       m.Data,
	}).Infof("Received message")

	// TODO: process message properly
	// TODO: acknowledge the message
	// TODO: submit processed message to bigquery (or another pubsub?)

	return nil
}
