import Sundog from "sundog"
import {empty, collect, project, where, clone, pick} from "fairmont"
import Interview from "panda-interview"

import MSG from "./msg"
{emptyQuestion, deleteQuestion, noTables, badTable} = MSG
import prerender from "../../../converter"

_extractArgs = (table) ->
  {TableName, KeySchema, AttributeDefinitions, ProvisionedThroughput} = table
  [TableName, KeySchema, AttributeDefinitions, ProvisionedThroughput]

_extractOptions = (table) ->
  defaults = ["TableName", "KeySchema", "AttributeDefinitions", "ProvisionedThroughput"]
  f = (key, value) -> key in defaults
  pick f, clone table


Table = (_AWS_, config, mixinConfig) ->
  _tables = if mixinConfig then prerender mixinConfig else []
  {AWS: {DynamoDB}} = Sundog _AWS_
  {tableGet, tableCreate, tableWaitForReady, tableEmpty, tableDel, tableWaitForDeleted} = DynamoDB

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
    for t in tables
      if !await tableGet t.TableName
        args = _extractArgs t
        options = _extractOptions t
        await tableCreate args..., options
        await tableWaitForReady t.TableName
    console.error "Done.\n"

  _empty = (name, options) ->
    tables = validateOperation name, options
    names = collect project "TableName", tables
    await ask emptyQuestion names
    console.error "Emptying bucket(s)..."
    await tableEmpty n for n in names when await tableGet n
    console.error "\nDone.\n"

  ls = ->
    tables = validateOperation(null, {all: true})
    console.log "Scanning AWS for mixin tables...\n"
    names = collect project "TableName", tables
    for n in names
      {TableStatus} = await tableGet n
      console.error "  - #{n} : #{TableStatus || "Not Found"}"
    console.error "\nDone.\n"

  _delete = (name, options) ->
    tables = validateOperation name, options
    names = collect project "TableName", tables
    await ask deleteQuestion names
    console.error "Deleting bucket(s)..."
    await tableDel n for n in names when await tableGet n
    await tableWaitForDeleted n for n in names
    console.error "\nDone.\n"

  {
    add
    empty: _empty
    ls
    list: ls
    delete: _delete
  }

export default Table
