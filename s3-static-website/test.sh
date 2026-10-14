#!/usr/bin/env bash
# Check the bucket serves the files in www/ as a static website.
set -euo pipefail

STACK=${STACK:-localstack}
bucket=$(pulumi stack output bucketName -s "$STACK")
site="http://$bucket.s3-website.localhost.localstack.cloud:4566"
echo "Website: $site"

response=$(curl -s -m 30 -w '\n%{http_code}' "$site/")
status=${response##*$'\n'}
body=${response%$'\n'*}
if [ "$status" != "200" ] || [[ "$body" != *"Hello, S3!"* ]]; then
  echo "Test failed: GET / returned HTTP $status: $body"
  exit 1
fi
echo "PASS: / serves www/index.html"

favicon=$(curl -s -m 30 -o /dev/null -w '%{http_code} %{content_type}' "$site/favicon.png")
if [ "$favicon" != "200 image/png" ]; then
  echo "Test failed: /favicon.png returned '$favicon', expected '200 image/png'"
  exit 1
fi
echo "PASS: /favicon.png is served as image/png"

echo "Test passed: the bucket serves the website"
