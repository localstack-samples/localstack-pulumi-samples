import os
import unittest
import json
import requests
import boto3
import time
from pulumi import automation as auto

from resource_appsync import OUTPUT_KEY_ENDPOINT, OUTPUT_KEY_API_KEY, OUTPUT_KEY_API_ID

class TestAppSync(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.STACK_NAME = "localstack"
        cls.REGION_NAME = "us-east-1"
        cls.WORK_DIR = os.path.join(os.path.dirname(__file__))
        cls.TENANT_ID = "123"
        cls.TENANT_NAME = "FirstCorp"

        # Configure LocalStack clients
        cls.endpoint_url = "http://localhost:4566"
        cls.appsync_client = boto3.client("appsync", region_name=cls.REGION_NAME, endpoint_url=cls.endpoint_url)
        cls.dynamodb_client = boto3.client("dynamodb", region_name=cls.REGION_NAME, endpoint_url=cls.endpoint_url)

        # Deploy the stack
        cls.stack = auto.create_or_select_stack(stack_name=cls.STACK_NAME, work_dir=cls.WORK_DIR)
        cls.stack.up(on_output=print)
        cls.outputs = cls.stack.outputs()

    @classmethod
    def tearDownClass(cls) -> None:
        cls.stack.destroy(on_output=print)
        cls.stack.workspace.remove_stack(cls.STACK_NAME)

    def test_appsync_api_exists(self):
        """Test if the AppSync API was created successfully"""
        api_id = self.outputs.get(OUTPUT_KEY_API_ID).value

        # Get the API using boto3
        response = self.appsync_client.get_graphql_api(apiId=api_id)
        self.assertEqual(response["graphqlApi"]["apiId"], api_id)

    def test_graphql_add_tenant(self):
        """Test the GraphQL mutation to add a tenant"""
        endpoint = self.outputs.get(OUTPUT_KEY_ENDPOINT).value
        api_key = self.outputs.get(OUTPUT_KEY_API_KEY).value

        query = {
            "query": f"""
            mutation AddTenant {{
                addTenant(id: "{self.TENANT_ID}", name: "{self.TENANT_NAME}") {{
                    id
                    name
                }}
            }}
            """
        }

        headers = {"Content-Type": "application/json", "x-api-key": api_key}
        response = requests.post(endpoint, json=query, headers=headers)

        self.assertEqual(response.status_code, 200)

        # Check the response data
        response_data = response.json()
        self.assertIn("data", response_data)
        self.assertIn("addTenant", response_data["data"])
        self.assertEqual(response_data["data"]["addTenant"]["id"], self.TENANT_ID)
        self.assertEqual(response_data["data"]["addTenant"]["name"], self.TENANT_NAME)

    def test_dynamodb_table_contains_data(self):
        """Test that the tenant was actually stored in DynamoDB"""
        self.test_graphql_add_tenant()  # Ensure the tenant exists

        # Find the actual table name
        tables = self.dynamodb_client.list_tables()
        table_name = next((t for t in tables["TableNames"] if "tenants" in t), "tenants")

        response = self.dynamodb_client.get_item(TableName=table_name, Key={"id": {"S": self.TENANT_ID}})

        self.assertIn("Item", response)
        self.assertEqual(response["Item"]["id"]["S"], self.TENANT_ID)
        self.assertEqual(response["Item"]["name"]["S"], self.TENANT_NAME)

if __name__ == "__main__":
    unittest.main()