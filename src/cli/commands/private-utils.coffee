import {curry} from "panda-garden"
import {query} from "panda-parchment"
import {select} from "panda-river"

where = curry (example, i) -> select (query example), i

export {where}
