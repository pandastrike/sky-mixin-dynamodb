import {cat} from "panda-parchment"
import {collect, project} from "panda-river"

Policy = (global, local) ->
  {region} = global
  names = cat(
    collect project "name", (local.tables ? [])
    local.access ? []
  )

  resources = []
  for n in names
    resources.push "arn:aws:dynamodb:#{region}:*:table/#{n}"
    resources.push "arn:aws:dynamodb:#{region}:*:table/#{n}/*"

  [
    Effect: "Allow"
    Action: [ "dynamodb:*" ]
    Resource: resources
  ]

export default Policy
