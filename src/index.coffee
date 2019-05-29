import {resolve} from "path"
import MIXIN from "panda-sky-mixin"
import {read as _read} from "panda-quill"
import {yaml} from "panda-serialize"

import getPolicyStatements from "./policy"
import preprocess from "./preprocessor"
import cli from "./cli"

mixin = do ->
  read = (name) -> _read resolve __dirname, "..", "..", "..", "files", name

  schema = yaml await read "schema.yaml"
  schema.definitions = yaml await read "definitions.yaml"
  template = await read "template.yaml"

  DynamoDB = new MIXIN {
    name: "dynamodb"
    schema
    template
    preprocess
    cli
    getPolicyStatements
  }
  DynamoDB

export default mixin
