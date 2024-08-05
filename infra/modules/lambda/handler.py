import json
import jwt

def lambda_handler(event, context):
    token = event['authorizationToken']
    try:
        # Decode JWT token
        decoded_token = jwt.decode(token, options={"verify_signature": False})
        
        # Extract Cognito groups
        cognito_groups = decoded_token['cognito:groups']

        # Define IAM policy
        policy = {
            "principalId": decoded_token['sub'],
            "policyDocument": {
                "Version": "2012-10-17",
                "Statement": []
            }
        }

        # Assign permissions based on groups
        if "SuperAdmin" in cognito_groups:
            policy["policyDocument"]["Statement"].append({
                "Effect": "Allow",
                "Action": "execute-api:Invoke",
                "Resource": "*"
            })
        elif "Admin" in cognito_groups:
            policy["policyDocument"]["Statement"].append({
                "Effect": "Allow",
                "Action": "execute-api:Invoke",
                "Resource": "arn:aws:execute-api:*:*:*"
            })
        elif "Superuser" in cognito_groups:
            policy["policyDocument"]["Statement"].append({
                "Effect": "Allow",
                "Action": "execute-api:Invoke",
                "Resource": "arn:aws:execute-api:*:*:*"
            })
        elif "Developer" in cognito_groups:
            policy["policyDocument"]["Statement"].append({
                "Effect": "Allow",
                "Action": "execute-api:Invoke",
                "Resource": "arn:aws:execute-api:*:*:*"
            })
        elif "User" in cognito_groups:
            policy["policyDocument"]["Statement"].append({
                "Effect": "Allow",
                "Action": "execute-api:Invoke",
                "Resource": "arn:aws:execute-api:*:*:*"
            })
        else:
            policy["policyDocument"]["Statement"].append({
                "Effect": "Deny",
                "Action": "execute-api:Invoke",
                "Resource": "*"
            })
        
        return policy

    except Exception as e:
        raise Exception(f"Unauthorized: {str(e)}")

