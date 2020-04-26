#!/usr/bin/env bash
function deploy(){
  gcloud functions deploy glue-pubsub \
    --trigger-topic=gas \
    --region=us-east4 \
    --runtime=go113 \
    --entry-point PubSubber \
    --project=cloud-glue \
    --service-account=sticky@cloud-glue.iam.gserviceaccount.com \
    --memory=128Mi
}

deploy "${1}"
