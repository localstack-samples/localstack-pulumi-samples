# Store SQS Messages in S3 Buckets

In this example, we will demonstrate how to store SQS messages in S3 buckets. We will use LocalStack to emulate AWS services locally with Pulumi's Node.js SDK.

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
pulumilocal stack init queues
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
