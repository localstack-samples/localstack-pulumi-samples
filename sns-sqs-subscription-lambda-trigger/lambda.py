import json
import os

import boto3


def handler(event, context):
    print(event)

    endpoint_url = os.environ["AWS_ENDPOINT_URL"]
    sqs = boto3.client("sqs", endpoint_url=endpoint_url)

    queue_url = os.environ['LAMBDA_RESULT_QUEUE']
    print("sending s3 message to", queue_url)
    sqs.send_message(QueueUrl=queue_url, MessageBody=json.dumps({"status":"ok", "raw_event": event}))

    return {"status": "ok"}
