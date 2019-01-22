#!/usr/bin/env bash

ALERT=$(cat -)

OUTPUT=$(echo $ALERT | jq '.output' | tr -d \")
RULE=$(echo $ALERT | jq '.rule' | tr -d \")
TIME=$(echo $ALERT | jq '.time' | tr -d \")
EPOCH=$(echo $ALERT | jq '.output_fields["evt.time"]' | tr -d \")
PRIORITY=$(echo $ALERT | jq '.priority' | tr -d \")
CONTAINER_IMAGE=$(echo $ALERT | jq '.output_fields["container.image"]' | tr -d \")
CONTAINER_NAME=$(echo $ALERT | jq '.output_fields["container.name"]' | tr -d \")
CONTAINER_ID=$(echo $ALERT | jq '.output_fields["container.id"]' | tr -d \")
USER=$(echo $ALERT | jq '.output_fields["user.name"]' | tr -d \")
COMMAND=$(echo $ALERT | jq '.output_fields["proc.cmdline"]' | tr -d \")
NAMESPACE=$(echo "$CONTAINER_NAME" | cut -f4 -d_)
POD=$(echo "$CONTAINER_NAME" | cut -f3 -d_)

curl -X POST https://hooks.slack.com/services/XXX \
-H 'Content-type: application/json' \
-d @- <<EOF
{
    "text": ":warning: :bird: New alert on <https://console.cloud.google.com/compute/instancesDetail/zones/us-east4-b/instances/`hostname`|`hostname`>",
    "attachments": [
        {
            "fallback": "$RULE",
            "color": "danger",
            "title": "$RULE",
            "title_link": "https://console.cloud.google.com/kubernetes/pod/us-east4-b/cloudlab/$NAMESPACE/$POD",
            "fields": [
                {
                    "title": "Kubernetes Workload",
                    "value": "<https://console.cloud.google.com/kubernetes/pod/us-east4-b/cloudlab/$NAMESPACE/$POD|$NAMESPACE/$POD>",
                    "short": true
                },
                {
                    "title": "Container Image",
                    "value": "$CONTAINER_IMAGE",
                    "short": true
                },
                {
                    "title": "User",
                    "value": "$USER",
                    "short": true
                },
                {
                    "title": "Command",
                    "value": "\`$COMMAND\`",
                    "short": true
                }
            ],
            "footer": "Falco Webhook",
            "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png",
            "ts": ${EPOCH::10}
        }
    ]
}
EOF
