# LocalStack Pulumi Examples

![LocalStack Community](https://img.shields.io/badge/LocalStack-Community-green)
![LocalStack Pro](https://img.shields.io/badge/LocalStack-Pro-blue)
![Integration Pulumi](https://img.shields.io/badge/Integration-Pulumi-orange)

This repository contains sample projects that can be deployed on your local machine using [LocalStack](https://localstack.cloud/).

Each example in the repository is self-contained and can be deployed individually using Pulumi & LocalStack on your local machine or in a CI/CD pipeline. The directory names are self-explanatory and each directory contains a `README.md` file with instructions on how to deploy the example.

## Prerequisites

* [LocalStack](https://localstack.cloud/)
* [Docker](https://docs.docker.com/get-docker/)
* [`awslocal` CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/)
* [Pulumi](https://www.pulumi.com/docs/get-started/install/)
* `make` & `jq`

If a sample project requires additional tools, it will be mentioned in the `README.md` file of the project.

## Configuration

Some of the samples require LocalStack Pro features. Each directory will have a Markdown badge indicating whether the sample requires LocalStack Pro or not. If you are leveraging a LocalStack Pro sample, make sure to properly configure the `LOCALSTACK_API_KEY` environment variable. You can find your API key in the [LocalStack Pro dashboard](https://app.localstack.cloud/account/apikeys) and you can refer to our [API key documentation](https://docs.localstack.cloud/getting-started/api-key/) for more details.

## Outline

| Sample Name                                                     | Description                                                                         |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------|
| [AppSync DynamoDB Endpoint](https://github.com/localstack/localstack-pulumi-samples/tree/master/appsync-dynamodb-endpoint)       | Sample demonstrating a GraphQL endpoint in AppSync with DynamoDB integration         |
| [AWS API Gateway Auth0](https://github.com/localstack/localstack-pulumi-samples/tree/master/aws-apigateway-auth0)                 | Integration of AWS API Gateway with Auth0 for secure authentication and authorization                          |
| [AWS Lambda StepFunctions](https://github.com/localstack/localstack-pulumi-samples/tree/master/aws-lambda-stepfunctions)         | Sample demonstrating the implementation of Step Functions for orchestrating AWS Lambda functions |
| [Elastic Kubernetes Service](https://github.com/localstack/localstack-pulumi-samples/tree/master/elastic-kubernetes-service)   | Sample for provisioning and configuring an Elastic Kubernetes Service (EKS) cluster           |
| [Lambda Kinesis Firehose ES](https://github.com/localstack/localstack-pulumi-samples/tree/master/lambda-kinesis-firehose-es)     | Sample showcasing the integration of Lambda, Kinesis, Firehose, and Elasticsearch          |
| [Lambda Layers](https://github.com/localstack/localstack-pulumi-samples/tree/master/lambda-layers)                             | Sample demonstrating the usage of Lambda Layers to manage shared code and dependencies          |
| [S3 SQS Queues](https://github.com/localstack/localstack-pulumi-samples/tree/master/s3-sqs-queues)                             | Sample for storing messages from Amazon Simple Queue Service (SQS) to Amazon S3          |
| [S3 Static Website](https://github.com/localstack/localstack-pulumi-samples/tree/master/s3-static-website)                     | Creating a static website hosted on Amazon S3 using Pulumi                                  |
| [Serverless REST API](https://github.com/localstack/localstack-pulumi-samples/tree/master/serverless-rest-api)                 | Sample for setting up a serverless REST API on AWS                                      |

## Checking out a single sample

To check out a single sample, you can use the following commands:

```bash
mkdir localstack-pulumi-samples && cd localstack-pulumi-samples
git init
git remote add origin -f git@github.com:localstack/localstack-pulumi-samples.git
git config core.sparseCheckout true
echo <LOCALSTACK_SAMPLE_DIRECTORY_NAME> >> .git/info/sparse-checkout
git pull origin master
```

The above commands use `sparse-checkout` to only pull the sample you are interested in.

## License

This code is available under the Apache 2.0 license.
