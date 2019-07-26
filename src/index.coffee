import getPolicy from "./policy"
import getTemplate from "./template"
import CLI from "./cli"

create = (SDK, global, meta, local) ->
  name = "dynamodb"
  policy = getPolicy global, local
  vpc = meta.vpc
  template = await getTemplate SDK, global, meta, local
  cli = CLI SDK, global, meta, local

  {name, policy, vpc, template, cli}

export default create
