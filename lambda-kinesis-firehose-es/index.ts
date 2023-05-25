import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

const config = new pulumi.Config();
const awsRegion = config.get("awsRegion") || "eu-west-1";
const lambdaRole = new aws.iam.Role("lambdaRole", {
    name: "demorole",
    assumeRolePolicy: `{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
`,
});

const firehoseRole = new aws.iam.Role("firehoseRole", {
    name: "firehose_test_role",
    assumeRolePolicy: `{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
`,
});

const demoKinesisStream = new aws.kinesis.Stream("demoKinesisStream", {
    name: "demo-kinesis-stream",
    shardCount: 1,
});

const demoLambda = new aws.lambda.Function("demoLambda", {
    code: new pulumi.asset.FileArchive("lambda.zip"),
    name: "demolambda",
    role: lambdaRole.arn,
    handler: "lambda.handler",
    runtime: "python3.9",
    environment: {
        variables: {
            STREAM_NAME: demoKinesisStream.name,
        },
    },
});

const demoLambdaUrl = new aws.lambda.FunctionUrl("demoLambdaUrl", {
    functionName: demoLambda.name,
    authorizationType: "NONE",
});
const demoEsDomain = new aws.elasticsearch.Domain("demoEsDomain", {
    domainName: "demo-domain",
    elasticsearchVersion: "7.10",
});

const demoSkippedDocsBucket = new aws.s3.BucketV2("demoSkippedDocsBucket", {bucket: "demo-skipped-docs-bucket"});
const demoFirehoseStream = new aws.kinesis.FirehoseDeliveryStream("demoFirehoseStream", {
    name: "demo-firehose-delivery-stream",
    destination: "elasticsearch",
    s3Configuration: {
        roleArn: firehoseRole.arn,
        bucketArn: demoSkippedDocsBucket.arn,
    },
    kinesisSourceConfiguration: {
        kinesisStreamArn: demoKinesisStream.arn,
        roleArn: firehoseRole.arn,
    },
    elasticsearchConfiguration: {
        domainArn: demoEsDomain.arn,
        roleArn: firehoseRole.arn,
        indexName: "test",
        typeName: "test",
    },
});
