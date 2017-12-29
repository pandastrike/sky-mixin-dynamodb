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


extractIndex = ({name, keys, projection}) ->
  out = {}
  out = extractName out, name
  out = extractKeys out, keys
  out = extractProjection out, projection
  out

LocalIndex = (out, ax) ->
  out.LocalSecondaryIndexes = (extractIndex index for index in ax)
  out

export default LocalIndex
