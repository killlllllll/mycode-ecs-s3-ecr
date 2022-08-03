variable "domain_name" {
  description = "domain name (or application name if no domain name available)"
  default = null
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "tags for all the resources, if any"
}

variable "hosted_zone" {
  default     = "cloudtoday.click"
  description = "Route53 hosted zone"
}

variable "acm_certificate_domain" {
  default     = "cloudtoday.click"
  description = "Domain of the ACM certificate"
}

variable "price_class" {
  default     = "PriceClass_All" 
  description = "CloudFront distribution price class"
}

variable "use_default_domain" {
  default     = false
  description = "Use CloudFront website address without Route53 and ACM certificate"
}

variable "upload_sample_file" {
  default     = false
  description = "Upload sample html file to s3 bucket"
}

# All values for the TTL are important when uploading static content that changes
# https://stackoverflow.com/questions/67845341/cloudfront-s3-etag-possible-for-cloudfront-to-send-updated-s3-object-before-t
variable "cloudfront_min_ttl" {
  default     =  10
  description = "The minimum TTL for the cloudfront cache"
}

variable "cloudfront_default_ttl" {
  default     = 86400
  description = "The default TTL for the cloudfront cache"
}

variable "cloudfront_max_ttl" {
  default     = 31536000
  description = "The maximum TTL for the cloudfront cache"
}

variable "provider_region" {
  default     = "ap-south-1"
  description = "provider_region_for_cloudfront"
}

variable "validation_method" {
  default     = "DNS"
}

variable "iam_policy_sid" {
  default     = 1
}

variable "iam_policy_getobject" {
  default     = "s3:GetObject"
}

variable "iam_policy_principles" {
  default     = "AWS"
}

variable "aws_s3_bucket_acl" {
  default  = "private"
}

variable "bucketversoning_status" {
  default  = "Enabled"
}

variable "s3bucket_object" {
  type = string
  default  = "index.html"
}

variable "s3bucket_content" {
  type = string
  default  = "text/html"
}

variable "awsroute53_zone" {
  default  = "false"
}

variable "zoneid_type" {
  default  = "A"
}

variable "cloudfront_origin" {
  default  = "s3-cloudfront"
}

variable "cloudfront_enabled" {
  default  = "true"
}

variable "ssl_supportmethod" {
  default  = "sni-only"
}

variable "minimum_protocol" {
  default  = "TLSv1.2_2021"
}

variable "error_code" {
  default  = 403
}

variable "response_code" {
  default  = 200
}

variable "error_caching" {
  default  = 0
}

variable "restrict_type" {
  default  = "none"
}

variable "aws_region" {
  default  = "ap-south-1"
}

variable "zonid" {}

variable "acm_certificate" {}

# variables.tf
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "health_check_path" {
  default = "/"
}

variable "container_name" {}

variable "service_name" {}

variable "container_port" {}

variable "cluster_name" {}

variable "accountid" {}

variable "env" {}

variable "repo_name" {}

variable "scan_image_on_push" {}

variable "image_tag_mutability" {}

variable "bucket_name" {}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}

variable "acl" {}

variable "versioning" {}

variable "health_check" {}

variable "fargate_cpu" {}

variable "app_port" {}

variable "fargate_memory" {}

variable "desired_count" {}

variable "aws_region" {}

variable "subnets" {}

variable "security_groups" {}

variable "targetgroup_arn" {}

variable "execution_role_arn" {}

