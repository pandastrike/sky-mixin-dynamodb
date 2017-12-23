# This helper module parses the desired and current ProvisionedThroughput on the
# whole table (or its indexes) and returns changes if an update is needed.
import {deepEqual} from "fairmont"

getThroughputChanges = (currentTable, desiredTable) ->
  current = [
    currentTable.ProvisionedThroughput.ReadCapacityUnits,
    currentTable.ProvisionedThroughput.WriteCapacityUnits
  ]
  desired = [
    desiredTable.ProvisionedThroughput.ReadCapacityUnits,
    desiredTable.ProvisionedThroughput.WriteCapacityUnits
  ]

  if deepEqual current, desired
    false
  else
    throughput: desiredTable.ProvisionedThroughput
    shorthand: "#{desired[0]} - #{desired[1]}"

export default getThroughputChanges
