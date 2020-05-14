title: LPA Codes
date: 12/05/2020
status: hidden

#### Purpose

The LPA code generator is an endpoint used by Sirius and Use an LPA application to 
generate, validate and revoke codes so that actors, 
such as individuals with legal power of attorney over a donor, 
can validate their identity and gain access to view a donors details.

This is accomplished by Sirius sending out letters with unique codes to actors who can then 
try and validate the code through the use an LPA website.

#### Consumers of this API

* Sirius - [opg-sirius](https://github.com/ministryofjustice/opg-sirius)
* Use an LPA - [opg-use-an-lpa](https://github.com/ministryofjustice/opg-use-an-lpa)

#### Integration Repositories

* LPA Codes - [opg-data-lpa-codes](https://github.com/ministryofjustice/opg-data-lpa-codes)

#### Integration Location

* Sirius Account (development, preproduction, production)
* EU West 1

#### Security

URLs to the endpoints are publicly accessible but locked down by AWS Authentication to only 
be accessible from the task ECS role of the API service for both Sirius and Use an LPA. 

#### Setup Local Environment

From the root of the repository you can type `docker-compose up -d`. This will bring up two services, 
a connexion service (that mocks aws gateway validation and routes requests) and a dynamodb local service 
which acts as the data store.

#### Setup Branch Environment

Branch environments are set up through the CI pipeline. However if you wish to build one manually 
for whatever reason then you can run the following (replacing <myworkspace> with whatever you want 
your workspace to be called):
```
cd terraform/environment
export TF_WORKSPACE=<myworkspace>
aws-vault exec identity -- terraform init
aws-vault exec identity -- terraform plan
aws-vault exec identity -- terraform apply  
```

More information on working with workspaces can be found in the technologies used tab.

#### ADRs

Can be found [here](https://github.com/ministryofjustice/opg-data-lpa-codes/tree/master/docs/architecture/decisions) 
and [here](https://github.com/ministryofjustice/opg-data/tree/master/docs/architecture).

#### Testing

Testing is accomplished by using a combination of unit tests and contract testing (using pact).

Unit tests can be run locally by running the following from the root directory of the repo:

```
virtualenv venv
source venv/bin/activate
pip install -r ./lambda_functions/v1/requirements/dev-requirements.txt
python -m pytest
```

Pact tests can only be run against pact broker currently. Local verification.

#### Design Diagrams

[work in progress](https://docs.google.com/drawings/d/1ghTX_lBpWcjYViPCzbbXQ0MRa2bcg2o0xf25GLSbAgI/edit)
