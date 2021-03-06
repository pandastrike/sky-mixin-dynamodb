extractName = (out, name) ->
  out.IndexName = name
  out

extractKeys = (out, dict) ->
  out.KeySchema = []
  for key, type of dict
    out.KeySchema.push
      AttributeName: key
      KeyType: type
  out

extractThroughput = (out, [read, write]) ->
  out.ProvisionedThroughput =
    ReadCapacityUnits: read
    WriteCapacityUnits: write
  out

extractProjection = (out, proj) ->
  if proj then {type, nonKeyAttributes} = proj else type = "ALL"
  out.Projection = ProjectionType: type
  if nonKeyAttributes
    out.Projection.NonKeyAttributes = nonKeyAttributes
  out


extractIndex = ({name, keys, projection, throughput}) ->
  out = {}
  out = extractName out, name
  out = extractKeys out, keys
  out = extractThroughput out, throughput if throughput?
  out = extractProjection out, projection
  out

GlobalIndex = (out, ax) ->
  out.GlobalSecondaryIndexes = (extractIndex index for index in ax)
  out

export default GlobalIndex
