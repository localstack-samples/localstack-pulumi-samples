# LocalStack Pulumi Samples

This repository contains sample projects that can be deployed on your local machine using [LocalStack](https://localstack.cloud/).

Each example in the repository is self-contained and can be deployed individually using Pulumi and LocalStack. The directory names are self-explanatory and each directory contains a `README.md` with sample-specific instructions.

## Prerequisites

- A valid [LocalStack for AWS license](https://localstack.cloud/pricing). Your license provides a [`LOCALSTACK_AUTH_TOKEN`](https://docs.localstack.cloud/getting-started/auth-token/).
- [Docker](https://docs.docker.com/get-docker/)
- [`localstack` CLI](https://docs.localstack.cloud/getting-started/installation/#localstack-cli)
- [`awslocal` CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/)
- [Pulumi](https://www.pulumi.com/docs/get-started/install/)
- [`pulumilocal` CLI](https://github.com/localstack/pulumi-local)
- `make` and `jq`

## Configuration

Set your auth token before running any sample:

```bash
export LOCALSTACK_AUTH_TOKEN=<your-auth-token>
```

Alternatively, use the LocalStack CLI:

```bash
localstack auth set-token <your-auth-token>
```

You can find your auth token in the [LocalStack Web Application](https://app.localstack.cloud/workspace/auth-token).

## Outline

| Sample Name | Description |
|---|---|
| [AppSync DynamoDB Endpoint](appsync-dynamodb) | GraphQL endpoint in AppSync with DynamoDB integration |
| [AWS API Gateway Auth0](aws-apigateway-auth0) | API Gateway integration with Auth0 for authentication and authorization |
| [AWS Lambda StepFunctions](aws-lambda-stepfunctions) | Step Functions orchestration with Lambda functions |
| [Elastic Kubernetes Service](elastic-kubernetes-service) | Provisioning and configuring an EKS cluster |
| [Lambda Kinesis Firehose ES](lambda-kinesis-firehose-es) | Lambda, Kinesis, Firehose, and Elasticsearch integration |
| [Lambda Layers](lambda-layers) | Lambda Layers for shared code and dependencies |
| [S3 SQS Queues](s3-sqs-queues) | Store SQS message data in S3 |
| [S3 Static Website](s3-static-website) | Static website hosting on S3 using Pulumi |
| [Serverless REST API](serverless-rest-api) | Serverless REST API using AWS managed services |
| [SNS, SQS, and Lambda integration](sns-sqs-subscription-lambda-trigger) | SNS topic + SQS queue + Lambda event flow |

## Checking Out A Single Sample

To check out only one sample directory:

```bash
mkdir localstack-pulumi-samples && cd localstack-pulumi-samples
git init
git remote add origin -f git@github.com:localstack-samples/localstack-pulumi-samples.git
git config core.sparseCheckout true
echo <LOCALSTACK_SAMPLE_DIRECTORY_NAME> >> .git/info/sparse-checkout
git pull origin master
```

The commands above use sparse checkout to pull only the sample you need.

## License

This code is available under Apache License 2.0.
