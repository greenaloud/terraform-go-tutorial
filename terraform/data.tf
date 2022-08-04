data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "wocho-test" {
  bucket = "wocho-test"
}

data "aws_route53_zone" "wocho-test" {
  name = "mldn.cc"  // 본 서비스에 적용할 루트 도메인.
}

data "aws_acm_certificate" "wocho-test" {
  domain      = "mldn.cc"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}