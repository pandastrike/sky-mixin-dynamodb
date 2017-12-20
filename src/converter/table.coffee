import extractGlobalIndexes from "./global-index"
import extractLocalIndexes from "./local-index"

extractName = (out, name) ->
  out.TableName = name
  out

extractKeys = (out, dict) ->
  out.KeySchema = []
  out.AttributeDefinitions = []
  for key, a of dict
    out.KeySchema.push
      AttributeName: key
      KeyType: a[1]
    out.AttributeDefinitions.push
      AttributeName: key
      AttributeType: a[0]
  out

extractThroughput = (out, throughput) ->
  out.ProvisionedThroughput =
    ReadCapacityUnits: throughput[0]
    WriteCapacityUnits: throughput[1]
  out

extractTags = (out, tags) ->
  out.Tags = tags if tags
  out


Table = ({name, keys, throughput, globalIndex, localIndex}, tags) ->
  out = {}
  out = extractName out, name
  out = extractKeys out, keys
  out = extractThroughput out, throughput
  out = extractGlobalIndexes out, globalIndex if globalIndex
  out = extractLocalIndexes out, localIndex if localIndex
  out = extractTags out, tags if tags
  out

export default Table
