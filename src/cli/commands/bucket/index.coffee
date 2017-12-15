import Sundog from "sundog"
import {empty} from "fairmont"
import Interview from "panda-interview"

import msg from "./msg"
{emptyQuestion, deleteQuestion, noBuckets, badBucket} = msg

Bucket = (_AWS_, config, mixinConfig) ->
  {AWS: {S3}} = Sundog _AWS_
  {bucketExists, bucketTouch, bucketEmpty, bucketDel} = S3

  validateOperation = (name, options) ->
    {buckets} = mixinConfig
    noBuckets() if !buckets || empty buckets
    badBucket() if name && !options.all && name not in buckets
    if options.all then buckets.sort() else [name]

  ask = (question) ->
    {ask: _ask} = new Interview()
    try
      answers = await _ask question
    catch e
    if !answers?.confirm
      console.error "\nProcess aborted.\n\nDone."
      process.exit()

  add = (name, options) ->
    names = validateOperation name, options
    console.error "Adding bucket(s)..."
    await bucketTouch n for n in names
    console.error "Done.\n"

  _empty = (name, options) ->
    names = validateOperation name, options
    await ask emptyQuestion names
    console.error "Emptying bucket(s)..."
    await bucketEmpty n for n in names when await bucketExists n
    console.error "\nDone.\n"

  ls = ->
    names = validateOperation(null, {all: true})
    console.log "Scanning AWS for mixin buckets...\n"
    for b in names
      status = if await bucketExists b then "Ready" else "Not Found"
      console.error "  - #{b} : #{status}"
    console.error "\nDone.\n"

  _delete = (name, options) ->
    names = validateOperation name, options
    await ask deleteQuestion names
    console.error "Deleting bucket(s)..."
    for n in names when await bucketExists n
      await bucketEmpty n
      await bucketDel n
    console.error "\nDone.\n"

  {
    add
    empty: _empty
    ls
    list: ls
    delete: _delete
  }

export default Bucket
