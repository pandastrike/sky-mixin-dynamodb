import extractGlobalIndexes from "./global-index"
import extractLocalIndexes from "./local-index"

extractName = (out, name) ->
  out.TableName = name
  out

extractAttributes = (out, dict) ->
  out.KeySchema = []
  out.AttributeDefinitions = []
  for key, a of dict
    out.AttributeDefinitions.push
      AttributeName: key
      AttributeType: a[0]
    if a.length == 2
      out.KeySchema.push
        AttributeName: key
        KeyType: a[1]
  out

extractThroughput = (out, throughput) ->
  out.ProvisionedThroughput =
    ReadCapacityUnits: throughput[0]
    WriteCapacityUnits: throughput[1]
  out

extractTags = (out, tags) ->
  out.Tags = tags if tags
  out


Table = ({name, attributes, throughput, globalIndexes, localIndexes}, tags) ->
  out = {}
  out = extractName out, name
  out = extractAttributes out, attributes
  out = extractThroughput out, throughput
  out = extractGlobalIndexes out, globalIndexes if globalIndexes
  out = extractLocalIndexes out, localIndexes if localIndexes
  out = extractTags out, tags if tags
  out

export default Table
