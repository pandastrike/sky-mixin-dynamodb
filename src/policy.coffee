# Panda Sky Mixin: DynamoDB Policy
# This mixin grants the API Lambdas access to the specified DynamoDB tables.  That IAM Role permission is rolled into your CloudFormation stack after being generated here.

import {collect, project} from "fairmont"

Policy = (config, global) ->
  # Grant total access to the tables listed in this mixin.
  # TODO: Consider limiting the actions on those tables and/or how to specify limitations within the mixin configuration.

  {region} = global.aws
  names = collect project "name", config.tables
  resources = ("arn:aws:dynamodb:#{region}:*:table/#{n}" for n in names)

  [
    Effect: "Allow"
    Action: [ "dynamodb:*" ]
    Resource: resources
  ]

export default Policy
