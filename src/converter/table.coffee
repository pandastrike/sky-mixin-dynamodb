import extractGlobalIndexes from "./global-index"
import extractLocalIndexes from "./local-index"

# TODO: Rewrite everything with flows!

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
  if !throughput? || throughput == "ON-DEMAND"
    out.BillingMode = "PAY_PER_REQUEST"
  else
    out.BillingMode = "PROVISIONED"
    out.ProvisionedThroughput =
      ReadCapacityUnits: throughput[0]
      WriteCapacityUnits: throughput[1]
  out

extractTags = (out, tags) ->
  out.Tags = tags if tags
  out

extractTTL = (out, ttl) ->
  out.TimeToLiveSpecification =
     AttributeName: ttl
     Enabled: true
  out


Table = (config, tags) ->
  {name, ttl, attributes, throughput, globalIndexes, localIndexes} = config
  out = {}
  out = extractName out, name
  out = extractAttributes out, attributes
  out = extractThroughput out, throughput
  out = extractGlobalIndexes out, globalIndexes if globalIndexes
  out = extractLocalIndexes out, localIndexes if localIndexes
  out = extractTags out, tags if tags
  out = extractTTL out, ttl if ttl
  out

export default Table
