# firehose-auditor

Google Cloud Function thingy that eats logs from a sink and does a thing


## Deploy

```raw
gcloud functions deploy --entry-point Firehose --service-account=cscc-firehose@kubesec.iam.gserviceaccount.com --trigger-topic=firehose --region=us-east1 --runtime go111 --source . firehose```
