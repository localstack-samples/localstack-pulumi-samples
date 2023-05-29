# Pulumi Sample to showcase SNS, SQS, and Lambda integration

In this example, we demonstrate SNS delivery to SQS queues via subscriptions, Lambda invocations through SQS event source mappings, and accessing LocalStack services from Lambda function.

The basic pipeline is:

- Publish -> SNS Topic (via user input)
- SNS Topic -> SQS queue (via SNS subscription)
- SQS Queue -> Lambda invocation (Lambda event source mapping)
- Lambda -> SQS (via AWS SDK `boto3` from within a Lambda)
- SQS -> Receive message (via user input)

## Prerequisites

- LocalStack
- Pulumi & `pulumilocal` CLI
- Docker
- `awslocal` CLI

## Starting up

Start LocalStack via:

```bash
localstack start -d
```

Create a new Pulumi stack via:

```bash
pulumilocal stack init dev
```

Set the AWS region to `us-east-1` via:

```bash
pulumilocal config set aws:region us-east-1
```

## Installing dependencies

Install the dependencies via:

```bash
yarn install
```

## Deploying the stack

Zip the Lambda function via:

```bash
zip lambda.zip lambda.py
```

To preview and deploy the stack, run:

```bash
pulumilocal up
```

After the Pulumi stack has been deployed, you should be able to check the available SQS queues & SNS topics via:

```bash
awslocal sqs list-queues
awslocal sns list-topics
```

## Testing the stack

You can publish a message to the SNS topic via:

```bash
awslocal sns publish \
	--topic arn:aws:sns:us-east-1:000000000000:trigger-event-topic \
	--message '{"event_type":"testing","event_payload":"hello world"}'
```

You can receive the message from the SQS queue via:

```bash
awslocal sqs receive-message --wait-time-seconds 10 --visibility-timeout=0 \
	--queue=http://localhost:4566/000000000000/lambda-result-queue \
```

## License

This code is available under the Apache 2.0 license.
