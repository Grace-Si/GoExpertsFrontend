terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  # .tfstate file save to S3 bucket
  backend "s3" {
    bucket = "tfstate-grace"
    key    = "terraform.tfstate"
  }
}

module "s3" {
  source = "./modules/s3" # Path to the module directory
  # You can set variables specific to this module here if needed
  oai_arn = module.cloudfront.oai_arn
}

module "ssl" {
  source = "./modules/ssl"
  # providers = {
  #   aws = aws.us-east-1
  # }
}

module "cloudfront" {
  source              = "./modules/cloudfront"
  s3-bucket           = module.s3.frontend-bucket #bucket id
  acm-certificate-arn = module.ssl.ssl_certificate_arn
}

module "R53" {
  source = "./modules/R53"
  cdn = module.cloudfront.cdn
}


