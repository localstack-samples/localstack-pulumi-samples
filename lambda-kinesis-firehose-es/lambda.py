import os
import logging
import boto3
import json

logger = logging.getLogger(__name__)


def handler(event, context):
    try:
        endpoint_url = None
        # Automatic boto instrumentation is a pro feature https://docs.localstack.cloud/user-guide/tools/transparent-endpoint-injection/
        # we'll do this manually here
        if os.environ.get("AWS_ENDPOINT_URL"):
            endpoint_url = os.environ["AWS_ENDPOINT_URL"]

        kinesis = boto3.client(
            "kinesis", endpoint_url=endpoint_url, region_name=os.environ["AWS_REGION"], verify=False
        )
        stream_name = os.environ['STREAM_NAME']
        kinesis.put_record(StreamName=stream_name, Data=json.dumps(event), PartitionKey="1")
        logger.info("Put record in stream %s.", stream_name)
    except Exception:
        logger.exception("Sending record to kinesis failed.")

    return {"body": "Hello World!"}
