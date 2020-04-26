#!/usr/bin/env bash

function deploy(){
  gcloud functions deploy glue-http \
    --trigger-http \
    --region=us-east4 \
    --runtime=go113 \
    --entry-point AppScriptHandler \
    --project=cloud-glue \
    --service-account=sticky@cloud-glue.iam.gserviceaccount.com \
    --memory=128Mi
}

deploy "${1}"
