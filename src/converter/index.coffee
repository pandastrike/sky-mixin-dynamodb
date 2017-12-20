# This helper accepts Sky's compressed representation of DynamoDB configuration from the mixin stanza and converts it to the full form required by AWS.  This converter is used by both the CloudFormation template preprocessor and the CLI augmentation.

import extractTable from "./table"

Converter = ({tables, tags}) -> extractTable table, tags for table in tables

export default Converter
