#!/usr/bin/env bash
# Call /hello with and without tokens and check the Lambda authorizer allows only "Bearer goodToken".
set -euo pipefail

STACK=${STACK:-localstack}
url=$(pulumi stack output url -s "$STACK")
# The output uses the AWS hostname, https://<api-id>.execute-api.<region>.amazonaws.com/<stage>/
api_id=$(echo "$url" | sed -E 's#^https?://([^.]+)\.execute-api\..*#\1#')
stage=$(echo "$url" | sed -E 's#^https?://[^/]+/([^/]+).*#\1#')
hello="http://$api_id.execute-api.localhost.localstack.cloud:4566/$stage/hello"
echo "API: $hello"

failed=0
# expect <description> <status> <body substring> [curl args...]
expect() {
  local description=$1 status=$2 substring=$3 response actual
  shift 3
  response=$(curl -s -m 60 -w '\n%{http_code}' "$hello" "$@")
  actual=${response##*$'\n'}
  response=${response%$'\n'*}
  if [ "$actual" = "$status" ] && [[ "$response" == *"$substring"* ]]; then
    echo "PASS: $description returned $actual"
  else
    echo "FAIL: $description returned $actual '$response', expected $status with '$substring'"
    failed=1
  fi
}

expect "no token" 401 ""
expect "Bearer goodToken" 200 "Hello world!" -H "Authorization: Bearer goodToken"
expect "Bearer badToken" 403 "" -H "Authorization: Bearer badToken"
expect "token without Bearer" 401 "" -H "Authorization: goodToken"

if [ "$failed" != 0 ]; then
  echo "Test failed"
  exit 1
fi
echo "Test passed: the authorizer allows only Bearer goodToken"
