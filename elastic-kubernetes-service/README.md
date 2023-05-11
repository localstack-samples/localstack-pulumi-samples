# Deploying an EKS Cluster using Pulumi on LocalStack

In this example, we will demonstrate how to deploy an AWS EKS cluster using Pulumi on LocalStack. With the help of the Pulumi Python SDK, we will declaratively provision AWS resources & infrastructure locally on LocalStack and on the real AWS cloud.

## Prerequisites

- LocalStack
- Pulumi & `pulumilocal` CLI
- Docker
- `awslocal` CLI
- `kubectl`

## Starting up

Start LocalStack via:

```bash
localstack start -d
```

Create a new Pulumi stack via:

```bash
pulumilocal stack init python-eks-testing
```

Set the AWS region to `us-east-1` via:

```bash
pulumi config set aws:region us-east-1
```

## Deploying the stack

To preview and deploy the stack, run:

```bash
pulumilocal up
```

You can view the deployed EKS cluster by running:

```bash
awslocal eks list-clusters
```

## Authenticating with the cluster

You can next update your KubeConfig, authenticate to your Kubernetes Cluster and verify you have API access and nodes running by running the following commands:

```bash
awslocal eks update-kubeconfig --name <CLUSTER_NAME>
kubectl get nodes
```

Replace `<CLUSTER_NAME>` with the name of your EKS cluster.

## License

This code is available under the Apache 2.0 license.
