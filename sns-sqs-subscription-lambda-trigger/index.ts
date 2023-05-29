import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

const trigger_event_topic = new aws.sns.Topic("trigger-event-topic", {name: "trigger-event-topic"});
const lambda_event_queue = new aws.sqs.Queue("lambda-event-queue", {name: "lambda-event-queue"});
const lambda_event_queue_sub = new aws.sns.TopicSubscription("lambda-event-queue-sub", {
    topic: trigger_event_topic.arn,
    protocol: "sqs",
    endpoint: lambda_event_queue.arn,
});

const lambda_result_queue = new aws.sqs.Queue("lambda-result-queue", {name: "lambda-result-queue"});

const event_echo_lambda = new aws.lambda.Function("event-echo-lambda", {
    code: new pulumi.asset.FileArchive("./lambda.zip"),
    name: "event-echo-lambda",
    role: "arn:aws:iam::000000000000:role/lambda-exec",
    handler: "lambda.handler",
    runtime: "python3.8",
    environment: {
        variables: {
            BOTO_ENDPOINT_URL: "http://172.17.0.1:4566",
            LAMBDA_RESULT_QUEUE: lambda_result_queue.url,
        },
    },
});

const sqs_lambda_trigger = new aws.lambda.EventSourceMapping("sqs-lambda-trigger", {
    eventSourceArn: lambda_event_queue.arn,
    enabled: true,
    functionName: event_echo_lambda.name,
    batchSize: 1,
});
