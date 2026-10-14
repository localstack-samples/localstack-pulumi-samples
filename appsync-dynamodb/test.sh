#!/usr/bin/env bash
# Run the Automation API integration tests in test_appsync.py. They re-run `up` on the
# LocalStack-configured stack, add a tenant through GraphQL, check DynamoDB, then destroy the stack.
set -euo pipefail

STACK=${STACK:-localstack}
if [ "$STACK" != "localstack" ]; then
  echo "test_appsync.py uses the stack named localstack"
  exit 1
fi

# boto3 in the tests needs credentials; LocalStack accepts any
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-test}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-test}

venv/bin/pip install --quiet boto3 requests
venv/bin/python -m unittest -v test_appsync
