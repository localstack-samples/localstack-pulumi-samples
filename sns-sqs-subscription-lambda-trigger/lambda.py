import os
import json

import boto3

def handler(event, context):
    print(event)

    endpoint_url = f"http://{os.getenv("LOCALSTACK_HOSTNAME")}:{os.getenv("EDGE_PORT")}"
    sqs = boto3.client("sqs", endpoint_url=endpoint_url)

    queue_url = os.environ['LAMBDA_RESULT_QUEUE']
    print("sending s3 message to", queue_url)
    sqs.send_message(QueueUrl=queue_url, MessageBody=json.dumps({"status":"ok", "raw_event": event}))

    return {"status": "ok"}
