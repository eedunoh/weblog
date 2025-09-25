data "aws_acm_certificate" "issued_cert" {
  domain      = "builtbyedunoh.com"
  statuses    = ["ISSUED"]
  types       = ["IMPORTED"]
  most_recent = true
}



output "acm_certificate_arn" {
  value = data.aws_acm_certificate.issued_cert.arn
}