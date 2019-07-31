package ddns

import (
	"encoding/json"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestUpdateDDNS(t *testing.T) {
	req1 := DdnsRequest{IpAddress: "127.0.0.1", DnsName: "test1.home.pulsifer.ca.", ApiToken: ""}
	req2 := DdnsRequest{IpAddress: "127.0.0.2", DnsName: "test2.home.pulsifer.ca.", ApiToken: ""}
	req3 := DdnsRequest{IpAddress: "127.0.0.3", DnsName: "test3.home.pulsifer.ca."}
	req4 := DdnsRequest{IpAddress: "127.0.0.4", DnsName: "test5.home.pulsifer.ca."}

	tests := []struct {
		request DdnsRequest
		want    DdnsResponse
	}{
		{request: req1, want: DdnsResponse{Status: "pending", Additions: 1, Deletions: 1}},
		{request: req2, want: DdnsResponse{Status: "pending", Additions: 1, Deletions: 1}},
		{request: req3, want: DdnsResponse{Status: "pending", Additions: 1, Deletions: 1}},
		{request: req4, want: DdnsResponse{Status: "pending", Additions: 1, Deletions: 1}},
	}

	for _, test := range tests {
		var out DdnsResponse
		ddnsReq, _ := json.Marshal(test.request)
		ddnsResp, _ := json.Marshal(test.want)

		req := httptest.NewRequest("GET", "/ddns", strings.NewReader(string(ddnsReq)))
		req.Header.Add("Content-Type", "application/json")

		rr := httptest.NewRecorder()
		UpdateDDNS(rr, req)

		if err := json.NewDecoder(rr.Body).Decode(&out); err != nil {
			t.Fatalf("Could not decode response body JSON: %v", err)
		}
		if got := out; got != test.want {
			t.Errorf("UpdateDDNS(%s) = %v, want %s", ddnsReq, got, ddnsResp)
		}
	}
}
