variable "aws_region" {
  description = "AWS region to deploy the bucket into."
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name. AWS appends a unique suffix so the name is globally unique."
  type        = string
  default     = "hello-world-site-"
}

variable "app_dir" {
  description = "Path to the static site files, relative to this module."
  type        = string
  default     = "../app"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    Project   = "hello-world-static-site"
    ManagedBy = "terraform"
  }
}
