# Deploying a Serverless REST API using DynamoDB, API Gateway, and Lambda on LocalStack

![LocalStack Community](https://img.shields.io/badge/LocalStack-Community-green)
![Integration Pulumi](https://img.shields.io/badge/Integration-Pulumi-orange)

In this example, we will demonstrate how to deploy a Serverless REST API using DynamoDB, API Gateway, and Lambda on LocalStack. With the help of the Pulumi Node.js SDK, we will declaratively provision AWS resources & infrastructure locally on LocalStack.

## Prerequisites

- LocalStack
- Pulumi & [`pulumilocal`](https://github.com/localstack/pulumi-local) CLI
- Docker
- `awslocal` CLI

## Starting up

Start LocalStack via:

```bash
localstack start -d
```

Create a new Pulumi stack via:

```bash
pulumilocal stack init count-api-testing
```

Set the AWS region to `us-east-1` via:

```bash
pulumi config set aws:region us-east-1
```

## Installing dependencies

Install the dependencies via:

```bash
yarn install
```

## Deploying the stack

To preview and deploy the stack, run:

```bash
pulumilocal up
```

You will see the REST API endpoint in the output, which you can use to test the API:

```bash
Outputs:
    endpoint: "https://ce9s6vf7jw.execute-api.us-east-1.amazonaws.com/stage/"

Resources:
    + 18 created

Duration: 41s
```

To access the [API Gateway URL via a local domain name](https://docs.localstack.cloud/user-guide/aws/apigateway/#accessing-http-apis-via-local-domain-name), we recommend the following URL format for accessing APIs is to use the following URL syntax with an `execute-api` hostname: `http://<apiId>.execute-api.localhost.localstack.cloud:4566/<stageId>/<path>`.

For this example, the URL would be: `https://ce9s6vf7jw.execute-api.localhost.localstack.cloud:4566/stage/`.

To test the API, run:

```bash
$ curl https://ce9s6vf7jw.execute-api.localhost.localstack.cloud:4566/stage/hello
{"route":"hello","count":1}
$ curl https://ce9s6vf7jw.execute-api.localhost.localstack.cloud:4566/stage/hello
{"route":"hello","count":2}
$ curl https://ce9s6vf7jw.execute-api.localhost.localstack.cloud:4566/stage/hello
{"route":"hello","count":3}
$ curl https://ce9s6vf7jw.execute-api.localhost.localstack.cloud:4566/stage/woohoo
{"route":"woohoo","count":1}
$ curl https://ce9s6vf7jw.execute-api.localhost.localstack.cloud:4566/stage/woohoo
{"route":"woohoo","count":2}
```

## License

This code is available under the Apache 2.0 license.
