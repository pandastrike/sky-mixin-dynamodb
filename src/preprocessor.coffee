# Panda Sky Mixin: DynamoDB
# This mixin allocates the requested DynamoDB tables into your CloudFormation stack. Tables are retained after stack deletion, so here we scan for them in DynamoDB before adding them to a new CFo template.

import Sundog from "sundog"
import {cat, isObject, plainText, camelCase, capitalize, empty} from "fairmont"

import warningMsg from "./warning-messages"

process = (_AWS_, config) ->
  {AWS: {DynamoDB: {tableExists}}} = Sundog _AWS_

  _exists = (name) ->
    try
      await tableExists name
    catch e
      warningMsg e
      throw e

  # Start by extracting out the S3 Mixin configuration:
  {env, tags=[]} = config
  c = config.aws.environments[env].mixins.dynamodb
  c = if isObject c then c else {}
  c.tags = cat (c.tags || []), tags

  {tables=[], tags} = c
  needed = []
  needed.push b for b in tables when !(await _exists b)

  # Build out a tables config array for the CloudFormation template, for
  # tables that don't already exist.
  tables =
    if empty needed
      []
    else
      for table in needed
        name: table
        resourceTitle: capitalize camelCase plainText table
        tags: tags

  {tables}


export default process
