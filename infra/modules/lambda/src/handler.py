import json
import os
import jwt
import requests
from jwt import PyJWKClient
import boto3
import time

# Initialize boto3 client for Cognito Identity Provider
client = boto3.client('cognito-idp')

# Global variables for caching
CACHE_TTL = 300  # Cache time-to-live in seconds (e.g., 5 minutes)
cache = {
    "user_pools": [],
    "timestamp": 0
}

def get_user_pools():
    current_time = time.time()
    # Check if cache is still valid
    if (current_time - cache['timestamp']) < CACHE_TTL and cache['user_pools']:
        print("Using cached user pools")
        return cache['user_pools']

    # Fetch user pools from AWS Cognito
    print("Fetching user pools from Cognito")
    user_pools = []
    response = client.list_user_pools(MaxResults=60)
    user_pools.extend(response['UserPools'])
    
    while 'NextToken' in response:
        response = client.list_user_pools(NextToken=response['NextToken'], MaxResults=60)
        user_pools.extend(response['UserPools'])
    
    user_pool_urls = [f"https://cognito-idp.{pool['Id'].split('_')[0]}.amazonaws.com/{pool['Id']}" for pool in user_pools]
    
    # Update cache
    cache['user_pools'] = user_pool_urls
    cache['timestamp'] = current_time

    return user_pool_urls

def get_jwks_client(issuer):
    jwks_url = f"{issuer}/.well-known/jwks.json"
    return PyJWKClient(jwks_url)

def validate_jwt_token(token, trusted_issuers):
    unverified_headers = jwt.get_unverified_header(token)
    issuer = jwt.decode(token, options={"verify_signature": False})['iss']

    if issuer not in trusted_issuers:
        print("Issuer not trusted")
        return None

    jwks_client = get_jwks_client(issuer)
    signing_key = jwks_client.get_signing_key_from_jwt(token)

    try:
        payload = jwt.decode(token, signing_key.key, algorithms=['RS256'], issuer=issuer)
        return payload
    except jwt.ExpiredSignatureError:
        print("Token has expired")
        return None
    except jwt.InvalidTokenError:
        print("Invalid token")
        return None
def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    # Retrieve request parameters from the Lambda function input:
    token = event['authorizationToken'].split(' ')[1]
    method_arn = event['methodArn']

    # Get all trusted issuers (user pool URLs)
    trusted_issuers = get_user_pools()
    print("Trusted issuers:", trusted_issuers)

    # Decode JWT token
    decoded_token = validate_jwt_token(token, trusted_issuers)
    if decoded_token is None:
        print("Unauthorized: Invalid token or issuer")
        raise Exception('Unauthorized')

    cognito_groups = decoded_token.get('cognito:groups', [])
    print("Cognito groups:", cognito_groups)

    # Parse the input for the parameter values
    tmp = method_arn.split(':')
    api_gateway_arn_tmp = tmp[5].split('/')
    aws_account_id = tmp[4]
    region = tmp[3]
    rest_api_id = api_gateway_arn_tmp[0]
    stage = api_gateway_arn_tmp[1]
    method = api_gateway_arn_tmp[2]
    resource = '/'

    if len(api_gateway_arn_tmp) > 3:
        resource += api_gateway_arn_tmp[3]

    print("Resource being accessed:", resource)

    # Define resource to group mapping
    resource_to_group_mapping = {
        "/knowledge/absorption": ["User", "Superuser", "Admin", "SuperAdmin", "Developer"],
        "/knowledge/query": ["User", "Superuser", "Admin", "SuperAdmin", "Developer"],
        "/tenant/resources": ["Superuser", "Admin", "SuperAdmin"],
        "/system/configurations": ["Admin", "SuperAdmin", "Developer"],
        "/system/resources": ["SuperAdmin"],
        "/tenant-management": ["SuperAdmin"],
    }

    # Perform authorization to return the Allow policy for correct parameters
    # and the 'Unauthorized' error, otherwise.
    allowed = False
    for res, allowed_groups in resource_to_group_mapping.items():
        if res in resource:
            print(f"Checking access for resource: {res} with allowed groups: {allowed_groups}")
            for group in allowed_groups:
                if group in cognito_groups:
                    allowed = True
                    print(f"Access granted for group: {group}")
                    break

    if allowed:
        response = generate_allow(decoded_token['sub'], method_arn)
        print('Authorized')
        return response
    else:
        print('Unauthorized')
        raise Exception('Unauthorized')  # Return a 401 Unauthorized response

# Helper function to generate IAM policy
def generate_policy(principal_id, effect, resource):
    auth_response = {}
    auth_response['principalId'] = principal_id
    if effect and resource:
        policy_document = {}
        policy_document['Version'] = '2012-10-17'
        policy_document['Statement'] = []
        statement_one = {}
        statement_one['Action'] = 'execute-api:Invoke'
        statement_one['Effect'] = effect
        statement_one['Resource'] = resource
        policy_document['Statement'] = [statement_one]
        auth_response['policyDocument'] = policy_document

    auth_response['context'] = {
        "stringKey": "stringval",
        "numberKey": 123,
        "booleanKey": True
    }

    print("Generated policy:", json.dumps(auth_response))
    return auth_response

def generate_allow(principal_id, resource):
    print(f"Generating allow policy for principal: {principal_id} and resource: {resource}")
    return generate_policy(principal_id, 'Allow', resource)

def generate_deny(principal_id, resource):
    print(f"Generating deny policy for principal: {principal_id} and resource: {resource}")
    return generate_policy(principal_id, 'Deny', resource)
