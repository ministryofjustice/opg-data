title: AWS Lambda
date: 12/05/2020
status: hidden

So far all our integrations use API gateway for the Rest APIs that integrate with Lambdas. 
These all run python code (further information on libraries of interest in python section).

The lambdas are deployed and managed by terraform and use layers for their dependencies which 
are populated with the requirements at run time of the CircleCI job. 
