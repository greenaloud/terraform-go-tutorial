terraform {
  required_version = ">= 0.12"
}

terraform {
  backend "s3" {
    bucket  = "wocho-test"
    key     = "terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
    acl     = "private"
  }
}