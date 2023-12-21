data "aws_route53_zone" "my-hosted-zone" {
  name = "${var.my_domain_name}."
}

# resource "aws_route53_record" "custom_domain_cname" {
#   zone_id = data.aws_route53_zone.my-hosted-zone.id
#   name    = var.custom_name
#   type    = "CNAME"
#   ttl     = 300
#   records = [aws_cloudfront_distribution.cdn_distribution.domain_name]
# }

resource "aws_route53_record" "custom_domain_a" {
  zone_id = data.aws_route53_zone.my-hosted-zone.id
  name    = var.custom_name
  type    = "A"

  alias {
    name                   = var.cdn.domain_name
    zone_id                = var.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
