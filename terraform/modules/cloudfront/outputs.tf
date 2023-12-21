output "oai_arn" {
  value = aws_cloudfront_origin_access_identity.oai.iam_arn
}

output "cdn" {
  value = aws_cloudfront_distribution.cdn_distribution
}