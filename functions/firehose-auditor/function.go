package p

import (
	"cloud.google.com/go/securitycenter/apiv1beta1"
	"context"
	"encoding/json"
	"fmt"
	log "github.com/sirupsen/logrus"
	securitycenterpb "google.golang.org/genproto/googleapis/cloud/securitycenter/v1beta1"
	"math/rand"
)

func Firehose(ctx context.Context, m PubSubMessage) error {
	var l AuditLog

	log.SetFormatter(&log.JSONFormatter{})

	// TODO: moar better
	org := "organizations/5046617773"
	randomStaticSourceID := "13893664994160590525"
	displayName := "firehose"
	// description := "example log firehose doer thingy"
	// cscc := "https://securitycenter.googleapis.com/v1beta1/organizations/5046617773"

	cctx := context.Background()
	c, err := securitycenter.NewClient(cctx)
	if err != nil {
		log.Fatalf("uh oh from: %v", err)
	}

	//req := &securitycenterpb.CreateSourceRequest{
	//	Parent: org,
	//	Source: &securitycenterpb.Source{
	//		DisplayName: displayName,
	//		Description: description,
	//	},
	//}
	//resp, err := c.CreateSource(cctx, req)

	req := &securitycenterpb.GetSourceRequest{
		Name: org + "/source/" + randomStaticSourceID,
	}

	source, err := c.GetSource(cctx, req)
	if err != nil {
		log.Fatalf("could not send cscc request for %s: %v", displayName, err)
	}
	log.Infof("omg: %v", source)

	if err := json.Unmarshal(m.Data, &l); err != nil {
		log.Fatalf("could not parse message: %v", err)
	}

	for _, auth := range l.ProtoPayload.AuthorizationInfo {
		permission := auth.Permission
		resource := auth.Resource
		allowed := auth.Granted

		email := l.ProtoPayload.AuthenticationInfo.Email
		method := l.ProtoPayload.Method

		log.WithFields(log.Fields{
			"email":      email,
			"allowed":    allowed,
			"method":     method,
			"permission": permission,
			"resource":   resource,
		}).Infof("audit")
		findingReq := &securitycenterpb.CreateFindingRequest{
			Parent:    source.Name,
			FindingId: fmt.Sprintf("%s", rand.Int63n(100000000000000000)),
			Finding: &securitycenterpb.Finding{
				Parent:       source.Name,
				ResourceName: resource,
				State:        1,
				Category:     "firehose",
				ExternalUri:  "https://k8s.lolwtf.ca",
			},
		}

		finding, err := c.CreateFinding(cctx, findingReq)
		if err != nil {
			log.Fatalf("Error creating finding: %v", err)
		}
		log.Infof("Finding created: %v", finding)
	}
	return nil
}
