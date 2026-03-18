# Pulumi Sample to showcase SNS, SQS, and Lambda integration

In this example, we demonstrate SNS delivery to SQS queues via subscriptions, Lambda invocations through SQS event source mappings, and accessing LocalStack services from Lambda function.

The basic pipeline is:

- Publish -> SNS Topic (via user input)
- SNS Topic -> SQS queue (via SNS subscription)
- SQS Queue -> Lambda invocation (Lambda event source mapping)
- Lambda -> SQS (via AWS SDK `boto3` from within a Lambda)
- SQS -> Receive message (via user input)

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
pulumilocal stack init dev
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
