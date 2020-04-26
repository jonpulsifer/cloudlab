package cloudfunction

import (
	"encoding/json"
	"net/http"

	log "github.com/sirupsen/logrus"
)

type GasRequest struct {
	Email       string `json:"email"`
	Spreadsheet string `json:"spreadsheet,omitempty"`
	Sheet       string `json:"sheet,omitempty"`
	Score       int    `json:"score,omittempty"`
}

type GasResponse struct {
	Status string `json:"status"`
}

func init() { log.SetLevel(log.DebugLevel) }
func AppScriptHandler(w http.ResponseWriter, r *http.Request) {
	var request GasRequest
	log.Debugln("Got request, attempting to decode")
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Errorf("Could not decode request from Google Apps Script: %v", err.Error())
		return
	}

	response := GasResponse{
		Status: "ok",
	}

	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		log.Errorf("Could not encode response: %v", err.Error())
	}
}
