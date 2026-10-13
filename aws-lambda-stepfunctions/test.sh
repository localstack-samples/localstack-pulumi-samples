#!/usr/bin/env bash
# Start the state machine and check the Lambda task returns "Hello world!".
set -euo pipefail

STACK=${STACK:-localstack}
MAX_ATTEMPTS=${MAX_ATTEMPTS:-60}
state_machine=$(pulumi stack output state_machine_arn -s "$STACK")
execution=$(lstk aws stepfunctions start-execution --state-machine-arn "$state_machine" \
  --query executionArn --output text)
echo "Execution: $execution"

status=RUNNING
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  status=$(lstk aws stepfunctions describe-execution --execution-arn "$execution" --query status --output text)
  [ "$status" != "RUNNING" ] && break
  sleep 2
done
output=$(lstk aws stepfunctions describe-execution --execution-arn "$execution" --query output --output text)
if [ "$status" != "SUCCEEDED" ] || [ "$output" != '"Hello world!"' ]; then
  echo "Test failed: execution ended $status with output $output"
  lstk aws stepfunctions get-execution-history --execution-arn "$execution" --query 'events[].type' --output text || true
  exit 1
fi
echo "PASS: the execution succeeded with output $output"

echo "Test passed: the state machine runs the Lambda"
