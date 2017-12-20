# Panda Sky Mixin: DynamoDB
# This mixin allocates the requested DynamoDB tables into your CloudFormation stack. Tables are retained after stack deletion, so here we scan for them in DynamoDB before adding them to a new CFo template.

import Sundog from "sundog"
import {yaml} from "panda-serialize"
import {cat, isObject, plainText, camelCase, capitalize, empty} from "fairmont"

import warningMsg from "./warning-messages"
import prerender from "./converter"

process = (_AWS_, config) ->
  {AWS: {DynamoDB: {tableGet}}} = Sundog _AWS_

  _exists = (name) ->
    try
      await tableGet name
    catch e
      warningMsg e
      throw e

  # Start by extracting out the DynamoDB Mixin configuration:
  {env, tags=[]} = config
  c = config.aws.environments[env].mixins.dynamodb
  c = if isObject c then c else {}
  c.tags = cat (c.tags || []), tags

  # Scan for which tables don't exist and list them as needed.
  {tables=[], tags} = c
  needed = []
  needed.push t for t in tables when !(await _exists t.name)

  # Build out a tables config array for needed tables in CloudFormation template
  tables = []
  if !empty needed
    descriptions = prerender {tables: needed, tags}
    for d in descriptions
      tables.push
        resourceTitle: capitalize camelCase plainText d.TableName
        tableDescription: yaml d

  {tables}


export default process