import pytest
from _pytest.main import Session

from pact_provider.check_pact_deployable import PactDeploymentCheck

import boto3
from moto import mock_secretsmanager, mock_sts


@pytest.mark.parametrize(
    "secret_code, environment, region",
    [("i_am_a_secret_code", "development", "eu-west-1")],
)
@pytest.mark.pact_test
@mock_secretsmanager
@mock_sts
def test_get_secret(secret_code, environment, region):
    client = boto3.client("sts")
    account_id = client.get_caller_identity()["Account"]
    print(account_id)

    role_to_assume = "arn:aws:iam::997462338508:role/get-pact-secret-production"
    response = client.assume_role(
        RoleArn=role_to_assume, RoleSessionName="assumed_role"
    )

    session = boto3.Session(
        aws_access_key_id=response["Credentials"]["AccessKeyId"],
        aws_secret_access_key=response["Credentials"]["SecretAccessKey"],
        aws_session_token=response["Credentials"]["SessionToken"],
    )
    client = session.client(service_name="secretsmanager", region_name=region)

    client.create_secret(Name="pactbroker_admin", SecretString=secret_code)

    assert PactDeploymentCheck.get_secret("pactbroker_admin") == secret_code
    assert PactDeploymentCheck.get_secret("local") == "dummy_password"
