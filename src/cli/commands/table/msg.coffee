Msg = do ->
  emptyDescription = (names) ->
    msg = "WARNING: You are about to destroy all contents of the DynamoDB table(s):\n"
    msg += "\n  - #{n}" for n in names
    msg += "\n\nThis is a destructive operation and cannot be undone."
    msg += "\n\nPlease confirm that you wish to continue. [Y/N]"

  emptyQuestion = (names) -> [
    name: "confirm"
    description: emptyDescription names
    default: "N"
  ]


  deleteDescription = (names) ->
    msg = "WARNING: You are about to delete the DynamoDB table(s):\n"
    msg += "\n  - #{n}" for n in names
    msg += "\n\nThis is a destructive operation and cannot be undone."
    msg += "\n\nPlease confirm that you wish to continue. [Y/N]"

  deleteQuestion = (names) -> [
    name: "confirm"
    description: deleteDescription names
    default: "N"
  ]

  noTables = ->
    console.error """
      Your Sky configuration specifies no tables for this environment.

      Done.

    """
    process.exit()

  badTable = (name) ->
    console.error """
      The table #{name} is not specified within your Sky configuration for this environment.  Please add it before continuing.

      Done.

    """
    process.exit()

  {emptyQuestion, deleteQuestion, noTables, badTable}

export default Msg
