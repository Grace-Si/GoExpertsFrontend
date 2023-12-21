variable "fe_bucket" {
  type        = string
  default     = "goexpertsfebucket"
  description = "bucket for static website hosting"
}

variable "oai_arn" {
  description = "ARN of the Origin Access Identity"
}