#!/usr/bin/env bash
# Call the counter API and check each route counts its own hits in DynamoDB.
set -euo pipefail

STACK=${STACK:-localstack}
endpoint=$(pulumi stack output endpoint -s "$STACK")
# The output uses the AWS hostname, https://<api-id>.execute-api.<region>.amazonaws.com/<stage>/
api_id=$(echo "$endpoint" | sed -E 's#^https?://([^.]+)\.execute-api\..*#\1#')
stage=$(echo "$endpoint" | sed -E 's#^https?://[^/]+/([^/]+).*#\1#')
base="http://$api_id.execute-api.localhost.localstack.cloud:4566/$stage"
echo "API: $base"

route="ci-$RANDOM$RANDOM"
other="$route-other"

# expect_count <route> <count>
expect_count() {
  local response
  response=$(curl -s -m 60 "$base/$1")
  if ! echo "$response" | jq -e --arg r "$1" --argjson c "$2" '.route == $r and .count == $c' > /dev/null 2>&1; then
    echo "Test failed: GET /$1 returned '$response', expected count $2"
    exit 1
  fi
  echo "PASS: GET /$1 returned count $2"
}

expect_count "$route" 1
expect_count "$route" 2
expect_count "$route" 3
expect_count "$other" 1

echo "Test passed: the API counts hits per route"
