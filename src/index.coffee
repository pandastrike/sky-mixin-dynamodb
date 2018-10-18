import {resolve} from "path"
import MIXIN from "panda-sky-mixin"
import {read} from "fairmont"
import {yaml} from "panda-serialize"

import getPolicyStatements from "./policy"
import preprocess from "./preprocessor"
import cli from "./cli"

mixin = do ->
  root = (name) -> resolve __dirname, "..", "..", "..", "files", name

  schema = yaml await read root "schema.yaml"
  schema.definitions = yaml await read root "definitions.yaml"
  template = await read root "template.yaml"

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
