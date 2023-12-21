variable "aws_region" {
  type        = string
  description = "AWS REGION"
}

variable "aws_access_key" {
  type        = string
  description = "AWS ACCESS KEY ID"
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS SECRET ACCESS KEY"
}

variable "tfstate_bucket" {
  type        = string
  default     = "tfstate-grace"
  description = "Name of the S3 bucket to store Terraform state"
}



# variable "my_domain" {
#   type        = string
#   default     = "*.graceau.com"
#   description = "my registered domain"
# }

# variable "hosted_zone" {
#   type        = string
#   default     = "Z00649252QTB51UYAQF9O"
#   description = "my hosted zone id"
# }

# variable "my_domain_name" {
#   type        = string
#   default     = "graceau.com"
#   description = "my own domain name"
# }

# variable "custom_name" {
#   type        = string
#   default     = "techscrum.graceau.com"
#   description = "my custom app domain name"
# }