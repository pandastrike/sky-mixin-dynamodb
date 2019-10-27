import {resolve} from "path"
import {merge} from "panda-parchment"
import {read as _read} from "panda-quill"
import {yaml} from "panda-serialize"

read = (name) ->
  presets = yaml await _read resolve __dirname,
    "..", "..", "..", "..", "files", "presets.yaml"
  presets[name]


expandPreset = (table) ->
  {name, ttl, preset} = table
  if preset?
    merge {name, ttl}, await read preset
  else
    table

export default expandPreset
