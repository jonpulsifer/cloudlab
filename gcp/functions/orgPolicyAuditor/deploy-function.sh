#!/usr/bin/env bash
function deploy(){
  gcloud functions deploy orgPolicyAuditor \
    --trigger-topic=orglog \
    --region=us-east4 \
    --runtime=go113 \
    --entry-point PubSubber \
    --project=kubesec \
    --service-account=loglog@kubesec.iam.gserviceaccount.com \
    --memory=128Mi \
    --set-env-vars DISCORD_TOKEN=""
}

deploy "${1}"
