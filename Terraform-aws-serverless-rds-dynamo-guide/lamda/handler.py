import json
import boto3
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    item = {
        "id": event.get("queryStringParameters", {}).get("id", "1"),
        "message": "Hello from Lambda!"
    }
    table.put_item(Item=item)
    return {
        "statusCode": 200,
        "body": json.dumps(item)
    }
