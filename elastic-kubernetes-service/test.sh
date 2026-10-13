#!/usr/bin/env bash
# Check the EKS cluster and its node group are active and kubectl sees the worker nodes as Ready.
set -euo pipefail

STACK=${STACK:-localstack}
MAX_ATTEMPTS=${MAX_ATTEMPTS:-60}
# kubectl runs `aws eks get-token`, which signs locally and needs credentials; LocalStack accepts any
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-test}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-test}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}

cluster=$(pulumi stack output cluster-name -s "$STACK")
echo "Cluster: $cluster"

lstk aws eks wait cluster-active --name "$cluster"
echo "PASS: the cluster is ACTIVE"

lstk aws eks wait nodegroup-active --cluster-name "$cluster" --nodegroup-name pulumi-eks-nodegroup
desired=$(lstk aws eks describe-nodegroup --cluster-name "$cluster" --nodegroup-name pulumi-eks-nodegroup \
  --query nodegroup.scalingConfig.desiredSize --output text)
echo "PASS: the node group is ACTIVE with desired size $desired"

kubeconfig=$(mktemp)
trap 'rm -f "$kubeconfig"' EXIT
lstk aws eks update-kubeconfig --name "$cluster" --kubeconfig "$kubeconfig" > /dev/null

workers=0
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  workers=$(kubectl --kubeconfig "$kubeconfig" get nodes --no-headers \
    -l '!node-role.kubernetes.io/control-plane' 2>/dev/null | awk '$2 == "Ready"' | wc -l | tr -d ' ')
  [ "$workers" -ge 1 ] && break
  echo "Attempt $attempt/$MAX_ATTEMPTS: no Ready worker node yet"
  sleep 5
done
kubectl --kubeconfig "$kubeconfig" get nodes -o wide || true
if [ "$workers" -lt 1 ]; then
  echo "Test failed: kubectl sees no Ready worker node"
  exit 1
fi
echo "PASS: kubectl sees $workers Ready worker node(s)"

echo "Test passed: the EKS cluster runs worker nodes"
