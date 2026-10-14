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

After deployment, get the API ID from `pulumilocal stack output url` (`https://<api-id>.execute-api.us-east-1.amazonaws.com/stage/`) and call the route through LocalStack. The authorizer only allows the token `Bearer goodToken`:

```bash
curl -H "Authorization: Bearer goodToken" http://<api-id>.execute-api.localhost.localstack.cloud:4566/stage/hello   # 200, <h1>Hello world!</h1>
curl -H "Authorization: Bearer badToken" http://<api-id>.execute-api.localhost.localstack.cloud:4566/stage/hello    # 404, awsx maps ACCESS_DENIED to 404
curl http://<api-id>.execute-api.localhost.localstack.cloud:4566/stage/hello                                        # 401
```
