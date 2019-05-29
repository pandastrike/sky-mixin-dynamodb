# This module handles the complexities involved when updating the configuration of a DynamoDB table. The AWS API prohibits simulatenous changes some combinations of table configuration.  Go through the cases and recursively complete an upsert.
import {curry} from "panda-garden"
import {merge, empty, keys, values, first, pick} from "panda-parchment"
import _create from "./create"
import getIndexChanges from "./changes/global-index"
import getThroughputChanges from "./changes/throughput"
DynamoDB = {}

_update = (t, indexChanges) ->
  {tableUpdate, tableWaitForReady} = DynamoDB
  {name, attributes} = t

  if t.ProvisionedThroughput
    f = (key) -> key in ["ReadCapacityUnits", "WriteCapacityUnits"]
    throughput = pick f, t.ProvisionedThroughput

  options = {}
  options.GlobalSecondaryIndexUpdates = indexChanges if indexChanges

  await tableUpdate name, attributes, throughput, options
  await tableWaitForReady name, true

update = (t) ->
  {tableGet, tableCreate} = DynamoDB
  create = _create DynamoDB
  current = await tableGet t.TableName

  # Create base object to define table update.
  table =
    name: t.TableName
    attributes: t.AttributeDefinitions

  # Case 1: The table doesn't exist.  Create it.
  if !current
    console.error "  -- Table #{t.TableName} does not exist. Creating..."
    return await create t

  # Case 2: Altering throughput configuration.
  {throughput, shorthand} = getThroughputChanges current, t
  if throughput
    console.error "  -- Updating #{t.TableName} throughput to  #{shorthand}"
    await _update merge table, ProvisionedThroughput: throughput
    return await update t

  # Case 3: Altering global secondary indexes on table.
  if current.GlobalSecondaryIndexes || t.GlobalSecondaryIndexes
    changes = getIndexChanges current, t
    if changes
      console.error "  -- Update #{t.TableName} indexes:"
      for change in changes
        console.error "    - #{values(change)[0].IndexName}: #{keys(change)[0]}"
      await _update table, changes
      return await update t

  # Case 4: TODO: Altering stream configuration


Update = curry (dynamodb, tables) ->
  DynamoDB = dynamodb
  await update t for t in tables

export default Update
