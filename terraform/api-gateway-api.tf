resource "aws_api_gateway_rest_api" "wocho-test" {
  name        = "wocho-test"
}

resource "aws_api_gateway_deployment" "wocho-test" {
  rest_api_id = aws_api_gateway_rest_api.wocho-test.id
  stage_name  = ""
}

resource "aws_api_gateway_stage" "wocho-test" {
  depends_on = [aws_api_gateway_deployment.wocho-test]

  stage_name           = "v1"
  rest_api_id          = aws_api_gateway_rest_api.wocho-test.id
  deployment_id        = aws_api_gateway_deployment.wocho-test.id
}