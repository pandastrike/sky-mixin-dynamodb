import {resolve} from "path"
import MIXIN from "panda-sky-mixin"
import {read} from "fairmont"
import {yaml} from "panda-serialize"

import preprocess from "./preprocessor"
import cli from "./cli"
import templateHelpers from "./template-helpers"

mixin = do ->
  schema = yaml await read resolve __dirname, "..", "files", "schema.yaml"
  schema.definitions = yaml await read resolve __dirname, "..", "files", "definitions.yaml"
  template = await read resolve __dirname, "..", "files", "template.yaml"

  DynamoDB = new MIXIN {
    name: "dynamodb"
    schema
    template
    preprocess
    cli
    templateHelpers
  }
  DynamoDB

export default mixin
