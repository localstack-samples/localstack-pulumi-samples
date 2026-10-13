import json
import os

import boto3


def handler(event, context):
    print(event)

    # LocalStack sets AWS_ENDPOINT_URL in the function; on AWS it is unset
    endpoint_url = os.environ.get("AWS_ENDPOINT_URL")
    sqs = boto3.client("sqs", endpoint_url=endpoint_url)

    queue_url = os.environ['LAMBDA_RESULT_QUEUE']
    print("sending sqs message to", queue_url)
    sqs.send_message(QueueUrl=queue_url, MessageBody=json.dumps({"status":"ok", "raw_event": event}))

    return {"status": "ok"}
