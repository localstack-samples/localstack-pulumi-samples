# Building Lambda Layers with Pulumi on LocalStack


This example shows how to build a Lambda Layer using Pulumi and deploy it to LocalStack.

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
pulumilocal stack init lambda-layers-localstack
pulumilocal config set aws:region us-east-1
```

## Deploying the stack

To preview and deploy the stack, run:

```bash
pulumilocal up
```

The following output should be displayed:

```bash
Outputs:
  + layerArn : "arn:aws:lambda:us-east-1:000000000000:layer:lambda_layer_name:1"
  + layerSize: 236
```

You can list the Lambda Layers via:

```bash
awslocal lambda list-layers
```

## License

This code is available under the Apache 2.0 license.
