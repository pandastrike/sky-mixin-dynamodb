# Helper to:
# 1) Break full specification into something SunDog can consume
# 2) Create the table
# 3) Wait until we get back "Ready" for the Table's status.
import {curry, clone, pick} from "fairmont"

create = curry (DynamoDB, table) ->
  {tableCreate, tableWaitForReady} = DynamoDB
  mainArgs = ["TableName", "KeySchema", "AttributeDefinitions", "ProvisionedThroughput"]
  optionalKeys = ["LocalSecondaryIndexes", "GlobalSecondaryIndexes", "StreamSpecification"]

  f = (key) -> key in mainArgs
  args = (v for k, v of pick f, clone table)

  f = (key) -> key in optionalKeys
  options = pick f, clone table
  await tableCreate args..., options
  await tableWaitForReady table.TableName

export default create
