Msg = do ->
  emptyDescription = (names) ->
    msg = "WARNING: You are about to destroy all contents of the S3 bucket(s):\n"
    msg += "\n  - #{n}" for n in names
    msg += "\n\nThis is a destructive operation and cannot be undone."
    msg += "\n\nPlease confirm that you wish to continue. [Y/N]"

  emptyQuestion = (names) -> [
    name: "confirm"
    description: emptyDescription names
    default: "N"
  ]


  deleteDescription = (names) ->
    msg = "WARNING: You are about to delete the S3 bucket(s):\n"
    msg += "\n  - #{n}" for n in names
    msg += "\n\nThis is a destructive operation and cannot be undone."
    msg += "\n\nPlease confirm that you wish to continue. [Y/N]"

  deleteQuestion = (names) -> [
    name: "confirm"
    description: deleteDescription names
    default: "N"
  ]

  noBuckets = ->
    console.error """
      Your Sky configuration specifies no buckets for this environment.

      Done.

    """
    process.exit()

  badBucket = (name) ->
    console.error """
      The bucket #{name} is not specified within your Sky configuration for this environment.  Please add it before continuing.

      Done.

    """
    process.exit()

  {emptyQuestion, deleteQuestion, noBuckets, badBucket}

export default Msg
