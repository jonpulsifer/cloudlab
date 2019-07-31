package ddns

import (
	"encoding/json"
	log "github.com/sirupsen/logrus"
	"golang.org/x/net/context"
	"golang.org/x/oauth2/google"
	dns "google.golang.org/api/dns/v1"
	"net/http"
	"os"
	"strings"
)

func init() {
	log.SetLevel(log.InfoLevel)
}

type DdnsRequest struct {
	IpAddress string `json:"ipaddress"`
	DnsName   string `json:"dnsname"`
	ApiToken  string `json:"apitoken"`
}

type DdnsResponse struct {
	Status    string `json:"status"`
	Additions int    `json:"additions"`
	Deletions int    `json:"deletions,omitempty"`
}

// UpdateDDNS is an HTTP Cloud Function with a request parameter.
func UpdateDDNS(w http.ResponseWriter, r *http.Request) {
	var apiToken string = os.Getenv("API_TOKEN")
	var project string = os.Getenv("GCP_PROJECT")
	var ddnsRequest DdnsRequest

	if project == "" {
		project = "homelab-ng"
	}

	if err := json.NewDecoder(r.Body).Decode(&ddnsRequest); err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Errorf("Could not decode request JSON: %v", err.Error())
	}

	if ddnsRequest.ApiToken != apiToken {
		http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
		log.Errorf("Invalid API token received: %s", ddnsRequest.ApiToken)
	}
	client, err := getCloudDnsService()
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Fatalf("Could not get DNS service: %v", err.Error())
	}

	managedZone, err := getManagedZoneFromDnsName(client, project, ddnsRequest.DnsName)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Fatalf("Could not get Managed Zone: %v", err.Error())
	}

	change, err := getDnsChange(client, project, managedZone, &ddnsRequest)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Fatalf("Could not create DNS change: %v", err.Error())
	}

	response := DdnsResponse{
		Status:    change.Status,
		Additions: len(change.Additions),
		Deletions: len(change.Deletions),
	}

	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Errorf("Could not encode response: %v", err.Error())
	}
	log.WithFields(log.Fields{
		"project":     project,
		"managedZone": managedZone.Name,
		"dnsname":     ddnsRequest.DnsName,
		"ip":          ddnsRequest.IpAddress,
		"status":      change.Status,
		"statuscode":  change.HTTPStatusCode,
	}).Infof("DNS Change Requested")
}

func getCloudDnsService() (*dns.Service, error) {
	c, err := google.DefaultClient(context.Background(), dns.CloudPlatformScope)
	if err != nil {
		return nil, err
	}
	return dns.New(c)
}

func getDnsChange(client *dns.Service, project string, managedZone *dns.ManagedZone, ddns *DdnsRequest) (*dns.Change, error) {
	var (
		additions  []*dns.ResourceRecordSet
		deletions  []*dns.ResourceRecordSet
		change     dns.Change
		dnsRequest = &dns.ResourceRecordSet{
			Name:    ddns.DnsName,
			Type:    "A",
			Ttl:     60,
			Rrdatas: []string{ddns.IpAddress},
		}
	)

	// get the current records for the requested endpoint
	resp, err := client.ResourceRecordSets.List(project, managedZone.Name).Do()
	if err != nil {
		return nil, err
	}

	for _, recordset := range resp.Rrsets {
		if recordset.Name == ddns.DnsName {
			deletions = append(deletions, recordset)
		}
	}
	additions = append(additions, dnsRequest)

	log.WithFields(log.Fields{
		"additions": len(additions),
		"deletions": len(deletions),
		"endpoint":  ddns.DnsName,
		"ip":        ddns.IpAddress,
	}).Debugf("Preparing DNS change")

	if len(deletions) == 0 {
		change = dns.Change{
			Additions: additions,
		}
	} else {
		change = dns.Change{
			Additions: additions,
			Deletions: deletions,
		}
	}

	return client.Changes.Create(project, managedZone.Name, &change).Context(context.Background()).Do()
}

func getManagedZoneFromDnsName(c *dns.Service, project string, dnsName string) (*dns.ManagedZone, error) {
	managedZoneList, err := c.ManagedZones.List(project).Do()
	if err != nil {
		return nil, err
	}

	for _, managedZone := range managedZoneList.ManagedZones {
		if strings.HasSuffix(dnsName, managedZone.DnsName) {
			return managedZone, nil
		}
	}
	return nil, nil
}
