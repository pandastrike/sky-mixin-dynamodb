import Sundog from "sundog"
import {empty, collect, project, where} from "fairmont"
import Interview from "panda-interview"

import _update from "./update"
import _create from "./create"
import MSG from "./msg"
import prerender from "../../../converter"

Table = (_AWS_, config, mixinConfig) ->
  _tables = if mixinConfig then prerender mixinConfig else []
  {AWS: {DynamoDB}} = Sundog _AWS_
  create = _create DynamoDB
  update = _update DynamoDB
  {tableGet, tableEmpty, tableDel, tableWaitForDeleted} = DynamoDB
  {emptyQuestion, deleteQuestion, noTables, badTable} = MSG

  validateOperation = (name, options) ->
    tables = collect project "TableName", _tables
    noTables() if empty tables
    badTable() if name && !options.all && name not in tables
    if options.all then _tables else collect where {TableName: name}, _tables

  ask = (question) ->
    {ask: _ask} = new Interview()
    try
      answers = await _ask question
    catch e
    if !answers?.confirm
      console.error "\nProcess aborted.\n\nDone."
      process.exit()

  add = (name, options) ->
    tables = validateOperation name, options
    console.error "Adding table(s)..."
    await create t for t in tables when !await tableGet t.TableName
    console.error "Done.\n"

  Empty = (name, options) ->
    tables = validateOperation name, options
    names = collect project "TableName", tables
    await ask emptyQuestion names
    console.error "Emptying table(s)..."
    await tableEmpty n for n in names when await tableGet n
    console.error "\nDone.\n"

  ls = ->
    tables = validateOperation(null, {all: true})
    console.log "Scanning AWS for mixin tables...\n"
    names = collect project "TableName", tables
    for n in names
      console.error "=".repeat 80
      table = await tableGet n
      if !table
        console.error "#{n} : NotFound"
        continue

      {TableStatus: status, GlobalSecondaryIndexes, ProvisionedThroughput: {ReadCapacityUnits: rCap, WriteCapacityUnits: wCap}} = table
      console.error "#{n} : #{status}   #{rCap} - #{wCap}"
      if GlobalSecondaryIndexes
        console.error "-".repeat 80
        console.error "  Global Indexes"
        for index in GlobalSecondaryIndexes
          {IndexName, IndexStatus, ProvisionedThroughput: {ReadCapacityUnits: rCap, WriteCapacityUnits: wCap}} = index
          console.error "  - #{IndexName} : #{IndexStatus}   #{rCap} - #{wCap}"
    console.error "=".repeat 80 if !empty tables
    console.error "\nDone.\n"

  Delete = (name, options) ->
    tables = validateOperation name, options
    names = collect project "TableName", tables
    await ask deleteQuestion names
    console.error "Deleting table(s)..."
    await tableDel n for n in names when await tableGet n
    await tableWaitForDeleted n for n in names
    console.error "\nDone.\n"

  Update = (name, options) ->
    tables = validateOperation name, options
    console.error "Updating table(s)..."
    await update tables
    console.error "\nDone.\n"

  {
    add
    empty: Empty
    ls
    list: ls
    delete: Delete
    update: Update
  }

export default Table
