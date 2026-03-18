# AppSync Dynamodb

This sample provisions a GraphQL API on AppSync backed by DynamoDB.

It creates:

- a DynamoDB table named `tenants`
- an AppSync GraphQL API with API key auth
- a `Mutation.addTenant(id, name)` resolver to write tenant records
- a `Query.getTenantById(id)` resolver to read tenant records

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
pip install -r requirements.txt
pulumilocal stack init dev
pulumilocal config set aws:region us-east-1
pulumilocal up
```

After deployment, use `pulumilocal stack output` to get the GraphQL endpoint and API key, then run GraphQL queries against the API.
