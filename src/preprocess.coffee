import Sundog from "sundog"
import {yaml} from "panda-serialize"
import {plainText, camelCase, capitalize, isEmpty} from "panda-parchment"

import prerender from "./converter"

preprocess = (SDK, global, meta, local) ->
  {tableGet} = Sundog(SDK).AWS.DynamoDB()
  {region} = global
  {vpc} = meta

  # Scan for which tables don't exist and list them as needed.
  {tables=[], tags} = local
  needed = []
  needed.push t for t in tables when !(await tableGet t.name)

  # Build out a tables config array for needed tables in CloudFormation template
  tables =
    for description in await prerender {tables: needed, tags}
      resourceTitle: capitalize camelCase plainText description.TableName
      tableDescription: yaml description

  if !vpc && isEmpty tables
    false
  else
    {tables, region, vpc}

export default preprocess
