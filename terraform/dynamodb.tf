resource "aws_dynamodb_table" "wocho-test" {
  name           = "wocho-test"
  billing_mode   = "PAY_PER_REQUEST"

  hash_key       = "user"
  range_key      = "id"

  attribute {
    name = "user"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }
}