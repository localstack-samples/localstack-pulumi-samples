#!/usr/bin/env bash
# Publish to the SNS topic and check the Lambda, fed by the subscribed SQS queue, echoes it to the result queue.
set -euo pipefail

STACK=${STACK:-localstack}
MAX_ATTEMPTS=${MAX_ATTEMPTS:-12}
topic_arn=$(pulumi stack output topicArn -s "$STACK")
result_queue=$(pulumi stack output resultQueueUrl -s "$STACK")
marker="ci${RANDOM}${RANDOM}"

lstk aws sns publish --topic-arn "$topic_arn" \
  --message "{\"event_type\":\"testing\",\"event_payload\":\"$marker\"}" > /dev/null
echo "Published payload $marker to $topic_arn"

found=""
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  bodies=$(lstk aws sqs receive-message --queue-url "$result_queue" --wait-time-seconds 10 \
    --max-number-of-messages 10 --query 'Messages[].Body' --output json)
  found=$(echo "$bodies" | jq -r --arg m "$marker" '.[]? | select(contains($m))' | head -1)
  [ -n "$found" ] && break
  echo "Attempt $attempt/$MAX_ATTEMPTS: no echo in $result_queue yet"
done
if [ -z "$found" ]; then
  echo "Test failed: the Lambda did not send the payload to $result_queue"
  exit 1
fi
if ! echo "$found" | jq -e '.status == "ok" and .raw_event.Records[0].eventSource == "aws:sqs"' > /dev/null; then
  echo "Test failed: unexpected message in $result_queue: $found"
  exit 1
fi
echo "PASS: SNS -> SQS -> Lambda -> SQS delivered the payload"

echo "Test passed: the SNS, SQS and Lambda pipeline works"
