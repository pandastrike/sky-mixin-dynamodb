# This helper module takes the current and desired global secondary indexes and calculates a set of updates to get from the former to the latter.
import {empty, collect, project, intersection, complement, curry, where} from "fairmont"
import getThroughputChanges from "./throughput"

addCreate = (index) ->
  Create: index
addDelete = (IndexName) ->
  Delete: {IndexName}
addUpdate = ({IndexName, ProvisionedThroughput}) ->
  Update: {IndexName, ProvisionedThroughput}


getIndex = curry (ax, name) ->
  results = collect where IndexName: name, ax
  results[0]

getIndexChanges = (currentTable, desiredTable) ->
  changes = []
  current = currentTable.GlobalSecondaryIndexes || []
  desired = desiredTable.GlobalSecondaryIndexes || []
  getDesired = getIndex desired
  getCurrent = getIndex current

  # Use set operations to calculate the changes.
  currentNames = collect project "IndexName", current
  desiredNames = collect project "IndexName", desired
  addNames = complement desiredNames, currentNames
  deleteNames = complement currentNames, desiredNames
  updateNames = intersection currentNames, desiredNames

  # Case 3a: creating a new index
  changes.push addCreate getDesired name for name in addNames

  # Case 3b: deleting an existing index
  changes.push addDelete name for name in deleteNames

  # Case 3c: updating an existing index
  for name in updateNames
    c = getCurrent name
    d = getDesired name
    {throughput} = getThroughputChanges c, d
    changes.push addUpdate d if throughput


  changes = false if empty changes
  changes

export default getIndexChanges
