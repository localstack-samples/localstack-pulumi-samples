# Store SQS Messages in S3 Buckets

![Integration Pulumi](https://img.shields.io/badge/Integration-Pulumi-orange)

In this example, we will demonstrate how to store SQS messages in S3 buckets. We will use LocalStack to emulate AWS services locally with Pulumi's Node.js SDK.

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
pulumilocal stack init queues
pulumilocal config set aws:region us-east-1
```

## Deploying the stack

To preview and deploy the stack, run:

```bash
pulumilocal up
```

You can view the deployed resources via:

```bash
awslocal sqs list-queues
awslocal s3 ls
```

## Sending messages to SQS

Run the following command to send a message to the SQS queue:

```bash
awslocal sqs send-message --queue-url <QUEUE_URL> --message-body test
```

You then will be able to find a `lastEvent.json` file which contains the message sent to the SQS queue by running the following command:

```bash
awslocal s3 ls <BUCKET_URL>
```

## License

This code is available under the Apache 2.0 license.
