import os
import boto3
from boto3.session import Session

# Set up for a local env for trialling purposes
domain = "opg-moj"
account = "288342028542"
repository = 'opg-pip-shared-code-dev'

if "CI" in os.environ:
    role_name = "sirius-ci"
else:
    role_name = "operator"


boto3.setup_default_session(region_name="eu-west-1",)
sts_role = boto3.client("sts")
role_to_assume = f"arn:aws:iam::{account}:role/{role_name}"

response_assume = sts_role.assume_role(
    RoleArn=role_to_assume, RoleSessionName="assumed_role"
)

session = Session(
    aws_access_key_id=response_assume["Credentials"]["AccessKeyId"],
    aws_secret_access_key=response_assume["Credentials"]["SecretAccessKey"],
    aws_session_token=response_assume["Credentials"]["SessionToken"],
    region_name="eu-west-1",
)

client = session.client("sts")
account_id = client.get_caller_identity()["Account"]
print(account_id)


code_artifact = session.client('codeartifact')

try:
    response = code_artifact.create_domain(domain=domain)
    response_create_domain = "Domain created. Response code: " + str(response["ResponseMetadata"]["HTTPStatusCode"])
except code_artifact.exceptions.ConflictException:
    response_create_domain = f"Domain, {domain} already exists"

print(response_create_domain)

try:
    response_create_repo = code_artifact.create_repository(
        domain=domain,
        domainOwner=account,
        repository=repository,
        description='OPG shared python code',
    )
    response_create_repo = "Repo created. Response code: " + str(response["ResponseMetadata"]["HTTPStatusCode"])
except code_artifact.exceptions.ConflictException:
    response_create_repo = f"Repository, {repository} already exists"

print(response_create_repo)

policy_document = '{"Version":"2012-10-17","Statement":\
[{"Sid":"ContributorPolicy",\
"Effect":"Allow",\
"Principal":{"AWS":"arn:aws:iam::288342028542:root"},\
"Action":["codeartifact:CreateRepository",\
"codeartifact:DeleteDomain",\
"codeartifact:DeleteDomainPermissionsPolicy",\
"codeartifact:DescribeDomain",\
"codeartifact:GetAuthorizationToken",\
"codeartifact:GetDomainPermissionsPolicy",\
"codeartifact:ListRepositoriesInDomain",\
"codeartifact:PutDomainPermissionsPolicy",\
"sts:GetServiceBearerToken"],\
"Resource":"*"}]}'

try:
    response_put_policy = code_artifact.put_domain_permissions_policy(
        domain=domain,
        policyDocument=policy_document
    )
    response_put_policy = "Repo created. Response code: " + str(response["ResponseMetadata"]["HTTPStatusCode"])
except:
    print("Error adding policy")
