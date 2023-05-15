# GraphQL Endpoint in AppSync & DynamoDB

In this example, we will demonstrate how to deploy a GraphQL endpoint in AppSync & DynamoDB, with an endpoint that contains one query and one mutation that get and put items. With the help of the Pulumi Node.js SDK, we will declaratively provision AWS resources & infrastructure locally on LocalStack and on the real AWS cloud.

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
pulumilocal stack init python-appsync-testing 
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
    endpoint: "http://localhost:4566/graphql/6b2597aa918540f99d1f618d2d"
    key     : [secret]

Resources:
    + 11 created

Duration: 20s
```

You can retrieve the GraphQL endpoint API key via the [AppSync Resource Browser](https://app.localstack.cloud/resources/appsync) on the LocalStack Web Application. Alternatively, you can retrieve it via the `awslocal` CLI:

```bash
awslocal appsync list-api-keys --api-id <API_ID>
```

You can test the deployed GraphQL endpoint via:

```bash
curl -XPOST -H "Content-Type:application/graphql" \
    -H "x-api-key:<API_KEY>" -d '{ "query": "mutation AddTenant { addTenant(id: \"123\", name: \"FirstCorp\") { id name } }" }' \
    <ENDPOINT_URL>
```

Replace the `<API_KEY>` and `<ENDPOINT_URL>` placeholders with the values from the Pulumi stack output and the LocalStack Web Application. You should see the following response:

```bash
{"data": {"addTenant": {"id": "123", "name": "FirstCorp"}}}
```

## License

This code is available under the Apache 2.0 license.
