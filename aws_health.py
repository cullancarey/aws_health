import requests
import boto3
import json

def send_sns(msg):
    client = boto3.client('sns')
    response = client.publish(
        TargetArn='arn:aws:sns:us-east-2:{account_id}:aws_health',
        Message=msg,
        Subject='Amazon Health Check'
    )

def status_request():
	import requests

	url = "https://status.aws.amazon.com/data.json"

	payload={}
	headers = {}

	response = requests.request("GET", url, headers=headers, data=payload).json()

	return response

def lambda_handler(event, context):
	x = status_request()
	results = x['current']
	issues = []
	if results:
		for result in results:
			issues.append(f"SERVICE: {result['service_name']} in {result['service']} has a current issue. \n DETAILS: {result['description']}")
	if issues:
		final = "\n\n".join(issues)
		send_sns(final)