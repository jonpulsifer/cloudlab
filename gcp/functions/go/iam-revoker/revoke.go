package revoke

import (
	"context"
	"encoding/json"
	"errors"
	log "github.com/sirupsen/logrus"
	auditpb "google.golang.org/genproto/googleapis/cloud/audit"
	"reflect"
	"strings"
	// loggingpb "google.golang.org/genproto/googleapis/logging/v2"
	// "cloud.google.com/go/logging"
	// "google.golang.org/genproto/googleapis/api/monitoredres"
)

// PubSubMessage is the payload of a Pub/Sub event.
// See https://cloud.google.com/functions/docs/calling/pubsub.
type PubSubMessage struct {
	Data []byte `json:"data"`
}

// LogEntry only cares about the log name and payload
type LogEntry struct {
	LogName  string           `json:"logName"`
	Payload  auditpb.AuditLog `json:"protoPayload"`
	Resource Resource         `json:"resource"`
}

// Resource is a MonitoredResource
type Resource struct {
	Type string `json:"type"`
}

func init() {
	log.SetLevel(log.DebugLevel)
	log.SetFormatter(&log.JSONFormatter{})
}

// Loglog gets a pubsub message
func Loglog(ctx context.Context, m PubSubMessage) error {
	l, err := getAuditLog(m)
	if err != nil {
		log.Errorf("Could not get audit log from pubsub message: %v", err)
		return err
	}
	if l == nil {
		return errors.New("Missing audit log")
	}

	log.WithFields(log.Fields{
		"Auth":             l.GetAuthenticationInfo().GetPrincipalEmail(),
		"MethodName":       l.GetMethodName(),
		"GetStatusGetCode": l.GetStatus().GetCode(),
	}).Infoln("Okie Dokie")
	return nil
}

func getAuditLog(m PubSubMessage) (*auditpb.AuditLog, error) {

	l, err := getLogEntry(m)
	if err != nil {
		log.Errorf("Could not get log entry: %v", err)
		return nil, err
	}

	var auditLog *auditpb.AuditLog
	if e := json.Unmarshal(string(l.Payload), auditLog); e != nil {
		log.WithFields(log.Fields{
			"Auth":             auditLog.GetAuthenticationInfo().GetPrincipalEmail(),
			"MethodName":       auditLog.GetMethodName(),
			"GetStatusGetCode": auditLog.GetStatus().GetCode(),
			"err":              e.Error(),
		}).Infoln("WEIRD")
	}

	if strings.HasSuffix(l.LogName, "activity") {
		log.WithFields(log.Fields{
			"logName":        l.LogName,
			"resource":       l.Resource.Type,
			"payloadGetAuth": l.Payload.GetAuthenticationInfo().GetPrincipalEmail(),
			"reflect":        reflect.TypeOf(l.Payload),
			"reflectAuth":    reflect.TypeOf(l.Payload.GetAuthenticationInfo().GetPrincipalEmail()),
		}).Infoln("Processing write activity")
		return &l.Payload, nil
	}

	log.WithFields(log.Fields{
		"logName": l.LogName,
	}).Debugf("Skipped")

	return nil, nil
}

func getLogEntry(m PubSubMessage) (*LogEntry, error) {
	var l *LogEntry
	if err := json.Unmarshal(m.Data, &l); err != nil {
		log.Infoln("LogEntry parse error: ", err)
		return nil, err
	}
	if l.Resource.Type == "organization" {
		log.WithFields(log.Fields{
			"logName": l.LogName,
		}).Infoln("Processing organization event")
	}
	return l, nil
}
