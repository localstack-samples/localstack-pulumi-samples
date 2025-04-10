import json
import pulumi
from pulumi import Output
import random
import string
from pulumi_aws import appsync, dynamodb, iam

OUTPUT_KEY_ENDPOINT = "endpoint"
OUTPUT_KEY_API_KEY = "api_key"
OUTPUT_KEY_API_ID = "api_id"

def create_appsync_api():
    table = dynamodb.Table(
        "tenants",
        hash_key="id",
        attributes=[dynamodb.TableAttributeArgs(name="id", type="S")],
        read_capacity=1,
        write_capacity=1,
    )

    role = iam.Role(
    "iam-role",
    assume_role_policy=json.dumps({
        "Version": "2012-10-17",
        "Statement": [{"Action": "sts:AssumeRole", "Principal": {"Service": "appsync.amazonaws.com"}, "Effect": "Allow"}]
    })
)

    # Define a policy that allows specific DynamoDB actions
    policy = iam.Policy(
        "iam-policy",
        policy=Output.json_dumps({
            "Version": "2012-10-17",
            "Statement": [{"Action": ["dynamodb:PutItem", "dynamodb:GetItem"], "Effect": "Allow", "Resource": [table.arn]}]
        })
    )

    # Attach the policy to the role
    iam.RolePolicyAttachment("iam-policy-attachment", role=role.name, policy_arn=policy.arn)

    schema = """
        type Query {
            getTenantById(id: ID!): Tenant
        }
        type Mutation {
            addTenant(id: ID!, name: String!): Tenant!
        }
        type Tenant {
            id: ID!
            name: String
        }
        schema {
            query: Query
            mutation: Mutation
        }
    """

    api = appsync.GraphQLApi("key", authentication_type="API_KEY", schema=schema)
    api_key = appsync.ApiKey("key", api_id=api.id)

    random_datasource_name = "".join(random.choice(string.ascii_letters) for _ in range(15))

    data_source = appsync.DataSource(
        "tenants-ds",
        name=random_datasource_name,
        api_id=api.id,
        type="AMAZON_DYNAMODB",
        dynamodb_config=appsync.DataSourceDynamodbConfigArgs(table_name=table.name),
        service_role_arn=role.arn,
    )

    appsync.Resolver(
        "get-resolver",
        api_id=api.id,
        data_source=data_source.name,
        type="Query",
        field="getTenantById",
        request_template="""{"version": "2017-02-28", "operation": "GetItem", "key": {"id": $util.dynamodb.toDynamoDBJson($ctx.args.id)}}""",
        response_template="$util.toJson($ctx.result)",
    )

    appsync.Resolver(
        "add-resolver",
        api_id=api.id,
        data_source=data_source.name,
        type="Mutation",
        field="addTenant",
        request_template="""{
            "version" : "2017-02-28",
            "operation" : "PutItem",
            "key" : {
                "id" : $util.dynamodb.toDynamoDBJson($ctx.args.id)
            },
            "attributeValues" : {
                "name": $util.dynamodb.toDynamoDBJson($ctx.args.name)
            }
        }
        """,
        response_template="$util.toJson($ctx.result)",
    )

    pulumi.export(OUTPUT_KEY_ENDPOINT, api.uris["GRAPHQL"])
    pulumi.export(OUTPUT_KEY_API_KEY, api_key.key)
    pulumi.export(OUTPUT_KEY_API_ID, api.id)

    return api, api_key, api.uris["GRAPHQL"]
