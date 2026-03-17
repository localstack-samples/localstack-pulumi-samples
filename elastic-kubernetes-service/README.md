# Deploying an EKS Cluster using Pulumi on LocalStack


In this example, we will demonstrate how to deploy an AWS EKS cluster using Pulumi on LocalStack. With the help of the Pulumi Python SDK, we will declaratively provision AWS resources & infrastructure locally on LocalStack and on the real AWS cloud.

## Prerequisites

- A valid [LocalStack for AWS license](https://localstack.cloud/pricing). Your license provides a [`LOCALSTACK_AUTH_TOKEN`](https://docs.localstack.cloud/getting-started/auth-token/).
- [Docker](https://docs.docker.com/get-docker/)
- [`localstack` CLI](https://docs.localstack.cloud/getting-started/installation/#localstack-cli)
- [`awslocal` CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/)
- [Pulumi](https://www.pulumi.com/docs/get-started/install/)
- [`pulumilocal` CLI](https://github.com/localstack/pulumi-local)
- `make` and `jq`

## Start LocalStack

```bash
export LOCALSTACK_AUTH_TOKEN=<your-auth-token>
localstack auth set-token $LOCALSTACK_AUTH_TOKEN
localstack start -d
localstack wait -t 30
```

## Initialize Pulumi Stack

```bash
pulumilocal stack init python-eks-testing
pulumilocal config set aws:region us-east-1
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

Replace `<CLUSTER_NAME>` with the name of your EKS cluster. For further details, see the [LocalStack EKS documentation](https://docs.localstack.cloud/user-guide/aws/elastic-kubernetes-service/).

## License

This code is available under the Apache 2.0 license.
