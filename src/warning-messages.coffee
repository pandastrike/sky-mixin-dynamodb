msg = (e) ->
  switch e.statusCode
    when 403
      console.error """
      WARNING: DynamoDB #{name} exists, these AWS credentials do not grant
      access.  Currently, Sky cannot manipulate this table.
      """
    when 301
      console.error """
      WARNING: DynamoDB #{name} exists, but is in a Region other than
      specified in sky.yaml. Currently, Sky cannot manipulate this table.
      """

export default msg
