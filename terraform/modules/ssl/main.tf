# SSL can only be create in region us-east-1
provider "aws" {
    alias  = "us-east-1"
    region = "us-east-1"
}

# create SSL certificate
resource "aws_acm_certificate" "ssl-certificate" {

    provider = aws.us-east-1

    domain_name       = var.my_domain
    validation_method = "DNS"

      tags = {
        Name = "CloudFront SSL Certificate"
      }
      lifecycle {
        create_before_destroy = true
      }
}

# must be commented out when creating SSL certificate and uncommeted once SSL certificate is created successfully
locals {
  domain_validation_options_map = { for option in tolist(toset(aws_acm_certificate.ssl-certificate.domain_validation_options)) : option.resource_record_name => option }
}

resource "aws_route53_record" "validation" {

      depends_on = [ aws_acm_certificate.ssl-certificate ]

  for_each = local.domain_validation_options_map

  zone_id = var.hosted_zone
  allow_overwrite = true # This is what allowed for conflict resolution in DNS
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = "300"
}

resource "aws_acm_certificate_validation" "default" {
  provider           = aws.us-east-1
  certificate_arn    = aws_acm_certificate.ssl-certificate.arn
  validation_record_fqdns = [
    for record_key, record in aws_route53_record.validation : record.fqdn 
  ]
  
  timeouts {
    create = "10m"
  }
}
