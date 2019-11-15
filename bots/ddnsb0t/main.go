package main

import (
	"bytes"
	"context"
	"encoding/json"
	"flag"
	"github.com/genuinetools/pkg/cli"
	ddns "github.com/jonpulsifer/cloudlab/functions/ddns"
	"github.com/sirupsen/logrus"
	"net"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"
)

const (
	fnURL string = "https://us-east4-homelab-ng.cloudfunctions.net/ddns"
)

var (
	apiToken string
	dnsName  string
	external bool
	once     bool
	interval time.Duration
	request  ddns.Request
	response ddns.Response
	verbose  bool
)

func main() {
	p := cli.NewProgram()
	p.Name = "ddnsb0t"
	p.Description = "A bot that fires a JSON blob down range to my cloud function"

	p.FlagSet = flag.NewFlagSet("global", flag.ExitOnError)
	p.FlagSet.StringVar(&dnsName, "hostname", "", "the DNS name to update")
	p.FlagSet.StringVar(&apiToken, "token", "", "API token for the cloud function")
	p.FlagSet.DurationVar(&interval, "interval", 5*time.Minute, "how long between each update (eg. 30s, 5m, 1h)")
	p.FlagSet.BoolVar(&external, "external", false, "use your external IP address")
	p.FlagSet.BoolVar(&once, "once", false, "run the thing once")
	p.FlagSet.BoolVar(&verbose, "verbose", false, "enable debug logging")

	p.Before = func(ctx context.Context) error {
		if len(dnsName) == 0 {
			hostname, err := os.Hostname()
			if err != nil {
				return err
			}
			dnsName = hostname
			logrus.Infof("using %s for DNS name", hostname)
		}
		if len(apiToken) == 0 {
			logrus.Infof("using DDNS_API_TOKEN environment variable")
			apiToken = os.Getenv("DDNS_API_TOKEN")
			if len(apiToken) == 0 {
				logrus.Fatalf("API token not found")
			}
		}
		if verbose {
			logrus.SetLevel(logrus.DebugLevel)
		}
		return nil
	}

	p.Action = func(ctx context.Context, args []string) error {

		ticker := time.NewTicker(interval)

		c := make(chan os.Signal, 1)
		signal.Notify(c, os.Interrupt)
		signal.Notify(c, syscall.SIGTERM)
		go func() {
			for sig := range c {
				ticker.Stop()
				logrus.Warnf("got %s, exiting", sig.String())
				os.Exit(0)
			}
		}()

		if once {
			err := update()
			if err != nil {
				return err
			}
			os.Exit(0)
		}

		for range ticker.C {
			err := update()
			if err != nil {
				return err
			}
		}

		return nil

	}

	p.Run()
}

func update() error {
	request.APIToken = apiToken
	request.DNSName = dnsName
	if external {
		externalIP, err := GetExternalIP()
		if err != nil {
			return err
		}
		request.IPAddress = externalIP
	} else {
		internalIP, err := GetInternalIP()
		if err != nil {
			return err
		}
		request.IPAddress = internalIP
	}

	logrus.WithFields(logrus.Fields{
		"ip":   request.IPAddress,
		"name": request.DNSName,
	}).Debugf("Built Request")
	requestJSON, err := json.Marshal(request)
	if err != nil {
		logrus.Errorf("Could not encode request: %v", err.Error())
		return err
	}

	req, err := http.NewRequest("POST", fnURL, bytes.NewBuffer(requestJSON))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	json.NewDecoder(resp.Body).Decode(&response)

	if resp.StatusCode != 200 {
		logrus.Errorf("got bad response: %s", resp.Status)
	} else {
		logrus.WithFields(logrus.Fields{
			"ip":        request.IPAddress,
			"dnsname":   request.DNSName,
			"status":    response.Status,
			"additions": response.Additions,
		}).Infof("DNS update requested")
	}
	return nil
}
func GetInternalIP() (string, error) {
	// mock a connection, this does not make a request
	conn, err := net.Dial("udp", "8.8.8.8:53")
	if err != nil {
		return "", err
	}
	return strings.Split(conn.LocalAddr().String(), ":")[0], nil
}

// dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com
// GetExternalIP uses Google's DNS TXT record cheatcode to get the external IP address
func GetExternalIP() (string, error) {
	r := net.Resolver{
		Dial:     GoogleResolver,
		PreferGo: true,
	}

	resp, err := r.LookupTXT(context.Background(), "o-o.myaddr.l.google.com")
	if err != nil {
		return "", err
	}
	return resp[0], nil
}

// https://github.com/golang/go/issues/19268
// GoogleResolver returns a custom dialer that uses ns1.google.com:53 instead of the default resolver
func GoogleResolver(ctx context.Context, network, address string) (net.Conn, error) {
	d := net.Dialer{}
	return d.DialContext(ctx, "udp", "ns1.google.com:53")
}
