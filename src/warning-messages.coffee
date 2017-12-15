msg = (e) ->
  switch e.statusCode
    when 403
      console.error """
      WARNING: S3 bucket #{name} exists, these AWS credentials do not grant
      access.  Currently, Sky cannot manipulate this bucket.
      """
    when 301
      console.error """
      WARNING: S3 bucket #{name} exists, but is in a Region other than
      specified in sky.yaml. Currently, Sky cannot manipulate this bucket.
      """

export default msg
