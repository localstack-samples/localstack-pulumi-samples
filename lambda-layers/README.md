# Building Lambda Layers with Pulumi on LocalStack

![LocalStack Pro](https://img.shields.io/badge/LocalStack-Pro-blue)
![Integration Pulumi](https://img.shields.io/badge/Integration-Pulumi-orange)

This example shows how to build a Lambda Layer using Pulumi and deploy it to LocalStack.

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
pulumilocal stack init lambda-layers-localstack
```

Set the AWS region to `us-east-1` via:

```bash
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
