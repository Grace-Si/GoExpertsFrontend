# create a Cloudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "oai" {
    comment = "OAI for Cloudfront to access s3 bucket" 
}

resource "aws_cloudfront_distribution" "cdn_distribution" {

  depends_on = [var.acm-certificate-arn]

  origin {
    domain_name = var.s3-bucket.bucket_regional_domain_name
    origin_id   = "S3-${var.s3-bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_root_object            = "/index.html"
  
  custom_error_response {
          error_code            = 403 
          error_caching_min_ttl = 10
          response_code         = 200 
          response_page_path    = "/index.html" 
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["AU", "AU"] # Add the desired countries or regions
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  default_cache_behavior {
    target_origin_id = "S3-${var.s3-bucket.id}"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100" # Optional: Set the desired price class (e.g., "PriceClass_100" for lowest cost)

  viewer_certificate {
    acm_certificate_arn      = var.acm-certificate-arn 
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  lifecycle {
    create_before_destroy = true
  }

}

