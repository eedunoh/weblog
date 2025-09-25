data "aws_acm_certificate" "issued_cert" {  # already created and issued by AWS
  domain      = "builtbyedunoh.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}


output "acm_certificate_arn" {
  value = data.aws_acm_certificate.issued_cert.arn
}