title: Circle CI
date: 12/05/2020
status: hidden

We use CircleCI for our deployment pipeline. Each repo has it's own circleci config file that 
controls the steps involved in deployment.

We do branch based deployments. In practice this means that we build an environment on every 
push to a branch and the environment is built using terraform workspaces to separate our 
environments.

As such we have the following environments

| Branch        | AWS Account   |
| ------------- |:-------------:|
| PR Based      | Development   |
| Development   | Development   |
| PreProduction | PreProduction |
| Production    | Production    |

In general the CircleCI jobs are quite standard but we do have one interesting bit of setup:
For pact, the pact broker can kick off an individual workflow to manage the pact check. 
This is done through a series of conditional variables that say which workflows 
can be kicked off.
