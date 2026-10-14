#!/usr/bin/env bash
# Send a message to the queue and check the subscribed Lambda stores it in the bucket as lastEvent.json.
set -euo pipefail

STACK=${STACK:-localstack}
MAX_ATTEMPTS=${MAX_ATTEMPTS:-40}
queue_url=$(pulumi stack output queueUrl -s "$STACK")
bucket_url=$(pulumi stack output bucketUrl -s "$STACK")
marker="ci-message-$(date +%s)-$RANDOM"

lstk aws sqs send-message --queue-url "$queue_url" --message-body "$marker" > /dev/null
echo "Sent '$marker' to $queue_url"

event=""
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  event=$(lstk aws s3 cp "$bucket_url/lastEvent.json" - 2>/dev/null || true)
  [[ "$event" == *"$marker"* ]] && break
  echo "Attempt $attempt/$MAX_ATTEMPTS: lastEvent.json does not hold the message yet"
  sleep 3
done
if ! echo "$event" | jq -e --arg m "$marker" '.Records[0].eventSource == "aws:sqs" and .Records[0].body == $m' > /dev/null 2>&1; then
  echo "Test failed: $bucket_url/lastEvent.json does not hold the SQS event: $event"
  exit 1
fi
echo "PASS: the Lambda stored the SQS event in $bucket_url/lastEvent.json"

echo "Test passed: SQS messages are stored in S3"
