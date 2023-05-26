# Deploying a State Machine using Step Functions & Lambda on LocalStack

In this example, we will demonstrate how to deploy a State Machine using Step Functions & Lambda on LocalStack. With the help of the Pulumi Python SDK, we will declaratively provision AWS resources & infrastructure locally on LocalStack and on the real AWS cloud.

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
pulumilocal stack init stepfunctions-dev
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

You can now run the following command to see the state machine ARN:

```bash
awslocal stepfunctions list-state-machines
```

## Run the State Machine

To run the State Machine, execute the following command:

```bash
awslocal stepfunctions start-execution --state-machine-arn '<STATE_MACHINE_ARN>'
```

Open the LocalStack logs to see the State Machine starting up:

```bash
2023-05-25T07:51:34.314  INFO --- [   asgi_gw_0] localstack.services.infra  : Starting mock StepFunctions service on http ports 443/4566 ...
2023-05-25T07:51:53.394  INFO --- [   asgi_gw_0] localstack.utils.bootstrap : Execution of "require" took 19131.07ms
2023-05-25T07:51:53.668  INFO --- [   asgi_gw_0] localstack.request.aws     : AWS stepfunctions.CreateStateMachine => 200
2023-05-25T07:51:53.703  INFO --- [   asgi_gw_1] localstack.request.aws     : AWS stepfunctions.DescribeStateMachine => 200
2023-05-25T07:51:53.723  INFO --- [   asgi_gw_0] localstack.request.aws     : AWS stepfunctions.ListTagsForResource => 200
2023-05-25T07:54:18.243  INFO --- [   asgi_gw_1] localstack.request.aws     : AWS stepfunctions.StartExecution => 200
```

## License

This code is available under the Apache 2.0 license.
