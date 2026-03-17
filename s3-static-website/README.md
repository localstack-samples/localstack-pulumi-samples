# Deploying a S3 Static Website using Pulumi on LocalStack

![Integration Pulumi](https://img.shields.io/badge/Integration-Pulumi-orange)

In this example, we will demonstrate how to deploy a [simple S3 Static Website](https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html) using Pulumi on LocalStack. With the help of the Pulumi Node.js SDK, we will declaratively provision AWS resources & infrastructure locally on LocalStack and on the real AWS cloud.

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
pulumilocal stack init website-testing
pulumilocal config set aws:region us-east-1
```

## Installing dependencies

Install the dependencies via:

```bash
yarn install
```

## Deploying the stack

To preview and deploy the stack, run:

```bash
pulumilocal up
```

After the Pulumi stack has been deployed, you should be able to check the available S3 buckets via:

```bash
awslocal s3 ls
```

You can access the S3 website by using the bucket name in the following format: `http://<BUCKET_NAME>.s3-website.localhost.localstack.cloud:4566`. Since the endpoint is configured to use `localhost.localstack.cloud`, no real AWS resources have been created.

## License

This code is available under the Apache 2.0 license.
