title: AWS Gateway
date: 12/05/2020
status: hidden

The pattern that we follow for the deployment of our Rest APIs is to manage them via terraform 
and to use an OpenAPI spec to generate them that handles the security and validation.

We use versions via stages and pass stage variables to the endpoints that point to different 
lambda deployments. Note, these are completely separate Lambda deployments and not versioned 
Lambdas (which is also possible but restricted our ability to fix up older versions).

Paths are product and environment specific and use delegated domains to create a hierarchy
to support this implementation.

The Rest APIs will be be accessible externally in production from
<product-name>.api.opg.service.justice.gov.uk which is a
sub domain of api.opg.service.justice.gov.uk and this zone is created in the
management account.

We use further subdomains for deployment to preproduction (pre) and development (dev) and
further subdomains of development for branch based deployment. For example, a uri to a
healthcheck endpoint created on PR1234 would like
PR1234.dev.api.<product-name>.api.opg.service.justice.gov.uk/v1/healthcheck.

New certs aren't created per branch as the sub branches use the wildcard cert for dev sub domain.

