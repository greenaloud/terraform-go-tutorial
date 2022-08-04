resource "aws_api_gateway_domain_name" "wocho-test" {
  domain_name              = "wocho.mldn.cc"  // api 엔드포인트로 사용할 서브도메인
  regional_certificate_arn = data.aws_acm_certificate.wocho-test.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "wocho-test" {
  name    = aws_api_gateway_domain_name.wocho-test.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.wocho-test.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.wocho-test.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.wocho-test.regional_zone_id
  }
}

resource "aws_api_gateway_base_path_mapping" "wocho-test" {
  api_id      = aws_api_gateway_rest_api.wocho-test.id
  stage_name  = "v1"
  domain_name = aws_api_gateway_domain_name.wocho-test.domain_name
}