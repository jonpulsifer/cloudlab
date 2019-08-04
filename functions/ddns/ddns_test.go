package ddns

import (
	"bytes"
	"encoding/json"
	dns "google.golang.org/api/dns/v1"
	"net/http/httptest"
	"reflect"
	"testing"
)

func Test_UpdateDDNS(t *testing.T) {
	tests := []struct {
		request Request
		want    Response
	}{
		{request: Request{IPAddress: "127.0.0.1", DNSName: "test1.home.pulsifer.ca.", APIToken: ""}, want: Response{Status: "pending", Additions: 1, Deletions: 1}},
		{request: Request{IPAddress: "127.0.0.2", DNSName: "home.pulsifer.ca.", APIToken: ""}, want: Response{Status: "pending", Additions: 1, Deletions: 1}},
		{request: Request{IPAddress: "127.0.0.3", DNSName: "test3.home.pulsifer.ca"}, want: Response{Status: "pending", Additions: 1, Deletions: 1}},
		{request: Request{IPAddress: "127.0.0.4", DNSName: "test4"}, want: Response{Status: "pending", Additions: 1, Deletions: 1}},
	}

	for _, test := range tests {
		var got Response
		ddnsReq, _ := json.Marshal(test.request)
		req := httptest.NewRequest("GET", "/ddns", bytes.NewReader(ddnsReq))
		req.Header.Add("Content-Type", "application/json")

		rr := httptest.NewRecorder()
		UpdateDDNS(rr, req)

		if err := json.NewDecoder(rr.Body).Decode(&got); err != nil {
			t.Fatalf("Could not decode response body JSON: %v", err)
		}
		if !reflect.DeepEqual(got, test.want) {
			t.Errorf("UpdateDDNS() = %v, want %v", got, test.want)
		}
	}
}

func Test_getDNSChange(t *testing.T) {
	type args struct {
		client      *dns.Service
		project     string
		managedZone *dns.ManagedZone
		request     *Request
	}
	tests := []struct {
		name    string
		args    args
		want    *dns.Change
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := getDNSChange(tt.args.client, tt.args.project, tt.args.managedZone, tt.args.request)
			if (err != nil) != tt.wantErr {
				t.Errorf("getDNSChange() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("getDNSChange() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_getManagedZoneFromDNSName(t *testing.T) {
	type args struct {
		c       *dns.Service
		project string
		DNSName string
	}
	tests := []struct {
		name    string
		args    args
		want    *dns.ManagedZone
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := getManagedZoneFromDNSName(tt.args.c, tt.args.project, tt.args.DNSName)
			if (err != nil) != tt.wantErr {
				t.Errorf("getManagedZoneFromDNSName() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("getManagedZoneFromDNSName() = %v, want %v", got, tt.want)
			}
		})
	}
}
