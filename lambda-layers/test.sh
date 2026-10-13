#!/usr/bin/env bash
# Check the layer version exists with its code and compatible runtimes.
set -euo pipefail

STACK=${STACK:-localstack}
layer_arn=$(pulumi stack output layerArn -s "$STACK")
layer_size=$(pulumi stack output layerSize -s "$STACK")
echo "Layer: $layer_arn ($layer_size bytes)"

if [ "${layer_size:-0}" -le 0 ]; then
  echo "Test failed: layerSize is '$layer_size'"
  exit 1
fi

layer=$(lstk aws lambda get-layer-version-by-arn --arn "$layer_arn")
if ! echo "$layer" | jq -e --arg arn "$layer_arn" --argjson size "$layer_size" '
    .LayerVersionArn == $arn and .Content.CodeSize == $size
    and (.CompatibleRuntimes | index("nodejs20.x") and index("nodejs22.x"))' > /dev/null; then
  echo "Test failed: unexpected layer version: $layer"
  exit 1
fi
echo "PASS: the layer version holds the code and lists nodejs20.x and nodejs22.x"

if ! lstk aws lambda list-layers --query 'Layers[].LayerName' --output text | grep -qw lambda_layer_name; then
  echo "Test failed: lambda_layer_name is missing from list-layers"
  exit 1
fi
echo "PASS: list-layers shows lambda_layer_name"

echo "Test passed: the Lambda layer is published"
