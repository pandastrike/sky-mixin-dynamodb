module.exports = """

  Usage: dynamodb [env] [command]

  Commands:

    table [subcommand]     Manage your DynamoDB mixin tables
      - list (ls)               Lists current status of mixin tables
      - add [name]              Creates the table if it does not exist
      - empty [name]            Deletes all items within the table
      - delete [name]           Deletes the table if it exists
      - update [name]           Upserts the table configuration

    Options:
      -a, --all     Effect all tables within your DynamoDB mixin configuration

  """
