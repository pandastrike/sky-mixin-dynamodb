module.exports = """

  Usage: s3 [env] [command]

  Commands:

    bucket [subcommand]     Manage your S3 mixin buckets
      - add [name]              Creates the bucket if it does not exist
      - empty [name]            Deletes all objects within the bucket
      - delete [name]           Deletes the bucket if it exists

    Options:
      -a, --all     Effect all buckets within your S3 mixin configuration

  """
