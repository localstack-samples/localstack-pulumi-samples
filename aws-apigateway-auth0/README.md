# AWS APIgateway Auth0

This sample deploys an API Gateway REST endpoint protected by a custom Lambda authorizer.

It creates:

- an API endpoint at `/hello`
- a Lambda-backed request authorizer
- a protected route that returns a simple HTML response when authorization succeeds

The project is based on an Auth0-style custom authorizer flow and is useful for local testing of token-based API access patterns.

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

## Run the Sample

```bash
npm install
pulumilocal stack init dev
pulumilocal config set aws:region us-east-1
pulumilocal up
```

After deployment, run `pulumilocal stack output url` to get the API URL and test it with an `Authorization` header expected by the authorizer logic.
