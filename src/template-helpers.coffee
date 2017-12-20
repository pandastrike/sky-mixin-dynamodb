import Handlebars from "handlebars"

Helpers = [
  name: "indent"
  method: (data, indent) ->
    out = data.replace /\n/g, '\n' + indent
    new Handlebars.SafeString(out);
]


export default Helpers
