#!/usr/bin/env bash
# Call the Function URL and check the event reaches Elasticsearch through Kinesis and Firehose.
set -euo pipefail

STACK=${STACK:-localstack}
MAX_ATTEMPTS=${MAX_ATTEMPTS:-60}
function_url=$(pulumi stack output functionUrl -s "$STACK")
es="http://$(pulumi stack output esEndpoint -s "$STACK")"
marker="ci${RANDOM}${RANDOM}"
echo "Function URL: $function_url"
echo "Elasticsearch: $es"

# The domain installs Elasticsearch on first use, so wait until it answers
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  curl -sf -m 10 "$es/_cluster/health" > /dev/null && break
  if [ "$attempt" = "$MAX_ATTEMPTS" ]; then
    echo "Test failed: Elasticsearch at $es did not come up"
    exit 1
  fi
  echo "Attempt $attempt/$MAX_ATTEMPTS: Elasticsearch is not ready yet"
  sleep 10
done
echo "PASS: the Elasticsearch domain is up"

response=$(curl -s -m 60 "${function_url%/}/?marker=$marker")
if [[ "$response" != *"Hello World!"* ]]; then
  echo "Test failed: the Function URL returned '$response'"
  exit 1
fi
echo "PASS: the Function URL answered"

hits=0
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  hits=$(curl -s -m 10 "$es/test/_search?q=$marker" | jq -r '.hits.total.value // 0' 2>/dev/null || echo 0)
  [ "$hits" -ge 1 ] && break
  echo "Attempt $attempt/$MAX_ATTEMPTS: the event is not indexed yet"
  sleep 5
done
if [ "$hits" -lt 1 ]; then
  echo "Test failed: no document with $marker in the test index"
  exit 1
fi
echo "PASS: the event was indexed in Elasticsearch"

echo "Test passed: Lambda -> Kinesis -> Firehose -> Elasticsearch works"
