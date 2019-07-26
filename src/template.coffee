import {resolve} from "path"
import {toJSON} from "panda-parchment"
import {read as _read} from "panda-quill"
import {yaml} from "panda-serialize"
import PandaTemplate from "panda-template"
import AJV from "ajv"

import preprocess from "./preprocess"

ajv = new AJV()
T = new PandaTemplate()

read = (name) ->
  await _read resolve __dirname, "..", "..", "..", "files", name

getTemplate = (SDK, global, meta, local) ->
  schema = yaml await read "schema.yaml"
  schema.definitions = yaml await read "definitions.yaml"
  template = await read "template.yaml"

  unless ajv.validate schema, local
    console.error toJSON ajv.errors, true
    throw new Error "failed to validate mixin configuration"

  if config = await preprocess SDK, global, meta, local
    T.render template, config
  else
    false

export default getTemplate
