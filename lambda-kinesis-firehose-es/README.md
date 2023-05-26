# Integrating Lambda, Kinesis, Firehose, Elasticsearch using Pulumi

This project is a simple example of how to integrate AWS Lambda, Kinesis, Firehose and Elasticsearch using Pulumi.

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
pulumilocal stack init lambda-kinesis-firehose-es
```

Set the AWS region to `us-east-1` via:

```bash
pulumi config set aws:region us-east-1
```

## Deploying the stack

To preview and deploy the stack, run:

```bash
pulumilocal up
```

You can fetch the Lambda Function URL & Elasticsearch domain endpoint via:

```bash
function_url=$(aws lambda get-function-url-config --function-name demolambda --region us-east-1 | jq -r .FunctionUrl)
elasticsearch_endpoint=$(aws es describe-elasticsearch-domain --domain-name demo-domain --region us-east-1 | jq -r .DomainStatus.Endpoint)
echo "Elasticsearch Endpoint: $elasticsearch_endpoint"
echo "Function URL: $function_url"
```

You can invoke the function via:

```bash
curl $function_url
```

## Starting a Kibana instance

You can start a Kibana instance pointing towards the Elasticsearch instance:

```bash
docker run --rm -p 5601:5601 -e "ELASTICSEARCH_HOSTS=http://172.17.0.1:4510" docker.elastic.co/kibana/kibana:7.10.0
```

You can browse the data in your Kibana instance: http://localhost:5601

## License

This code is available under the Apache 2.0 license.
