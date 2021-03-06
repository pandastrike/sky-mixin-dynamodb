import {resolve} from "path"
import {Command} from "commander"

import COMMANDS from './commands'

CLI = (SDK, global, local) ->
  (argv) ->
    [name, env] = argv
    program = new Command name

    program
      .command "table [subcommand] [name]"
      .allowUnknownOption()
      .option '-a, --all', 'Delete all buckets in your mixin list'
      .action (subcommand, name, options) ->
        table = await COMMANDS.table SDK, global, local
        if table[subcommand]
          table[subcommand] name, options
        else
          console.error "ERROR: unrecognized subcommand of 'dynamodb table'"
          program.help()

    program
      .command('*')
      .action  -> program.help()

    # TODO: This should be more detailed, customized for each subcommand, and
    # automatically extended with new commands and flags.  For now, this will
    # need to do.
    program.help = -> console.error COMMANDS.help

    # Begin execution.
    program.parse argv

export default CLI
