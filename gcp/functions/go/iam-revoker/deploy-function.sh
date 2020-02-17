#!/usr/bin/env bash
function deploy(){
  gcloud functions deploy loglog \
    --trigger-topic=orglog \
    --region=us-east4 \
    --runtime=go113 \
    --entry-point Loglog \
    --project=kubesec \
    --service-account=loglog@kubesec.iam.gserviceaccount.com \
    --memory=128Mi
}

deploy "${1}"
