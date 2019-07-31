package ddns

import (
	"encoding/json"
	"errors"
	"net/http"
	"os"
	"strings"

	log "github.com/sirupsen/logrus"
	"golang.org/x/net/context"
	"golang.org/x/oauth2/google"
	dns "google.golang.org/api/dns/v1"
)

func init() {
	log.SetLevel(log.InfoLevel)
}

// Request is the expected struct we want as a request
type Request struct {
	IPAddress string `json:"IPAddress"`
	DNSName   string `json:"DNSName"`
	APIToken  string `json:"APIToken"`
}

// Response is the response we expect to return
type Response struct {
	Status    string `json:"status"`
	Additions int    `json:"additions"`
	Deletions int    `json:"deletions,omitempty"`
}

// UpdateDDNS is an HTTP Cloud Function with a request parameter.
func UpdateDDNS(w http.ResponseWriter, r *http.Request) {
	var apiToken = os.Getenv("API_TOKEN")
	var project = os.Getenv("GCP_PROJECT")
	var request Request

	if project == "" {
		project = "homelab-ng"
	}

	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Errorf("Could not decode request JSON: %v", err.Error())
		return
	}

	if request.APIToken != apiToken {
		http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
		log.Errorf("Invalid API token received: %s", request.APIToken)
		return
	}

	client, err := getCloudDNSService()
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Fatalf("Could not get DNS service: %v", err.Error())
	}

	managedZone, err := getManagedZoneFromDNSName(client, project, request.DNSName)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Fatalf("Could not get Managed Zone: %v", err.Error())
	}

	change, err := getDNSChange(client, project, managedZone, &request)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Fatalf("Could not create DNS change: %v", err.Error())
	}

	response := Response{
		Status:    change.Status,
		Additions: len(change.Additions),
		Deletions: len(change.Deletions),
	}

	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Fatalf("Could not encode response: %v", err.Error())
	}
	log.WithFields(log.Fields{
		"project":     project,
		"managedZone": managedZone.Name,
		"dnsame":      request.DNSName,
		"ip":          request.IPAddress,
		"status":      change.Status,
		"statuscode":  change.HTTPStatusCode,
	}).Infof("DNS Change Requested")
}

func getCloudDNSService() (*dns.Service, error) {
	c, err := google.DefaultClient(context.Background(), dns.CloudPlatformScope)
	if err != nil {
		return nil, err
	}
	return dns.New(c)
}

func getDNSChange(client *dns.Service, project string, managedZone *dns.ManagedZone, request *Request) (*dns.Change, error) {
	var (
		additions  []*dns.ResourceRecordSet
		deletions  []*dns.ResourceRecordSet
		change     dns.Change
		dnsRequest = &dns.ResourceRecordSet{
			Name:    request.DNSName,
			Type:    "A",
			Ttl:     60,
			Rrdatas: []string{request.IPAddress},
		}
	)

	// get the current records for the requested endpoint
	resp, err := client.ResourceRecordSets.List(project, managedZone.Name).Do()
	if err != nil {
		return nil, err
	}

	for _, recordset := range resp.Rrsets {
		if recordset.Name == request.DNSName && recordset.Type == "A" {
			deletions = append(deletions, recordset)
		}
	}
	additions = append(additions, dnsRequest)

	log.WithFields(log.Fields{
		"additions": len(additions),
		"deletions": len(deletions),
		"endpoint":  request.DNSName,
		"ip":        request.IPAddress,
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

func getManagedZoneFromDNSName(c *dns.Service, project string, DNSName string) (*dns.ManagedZone, error) {
	managedZoneList, err := c.ManagedZones.List(project).Do()
	if err != nil {
		return nil, err
	}

	for _, managedZone := range managedZoneList.ManagedZones {
		if strings.HasSuffix(DNSName, managedZone.DnsName) {
			return managedZone, nil
		}
	}
	return nil, errors.New("No managed zone found")
}
