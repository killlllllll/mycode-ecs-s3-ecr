provider "aws" {
  region = "ap-south-1"
}

locals {
  default_certs = var.use_default_domain ? ["default"] : []
  acm_certs     = var.use_default_domain ? [] : ["acm"]
  domain_name   = var.use_default_domain ? [] : [var.domain_name]
}


data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}-${var.env}/*",
      "arn:aws:s3:::${var.bucket_name}-${var.env}",
    ]

    principals {
      type = "AWS"

      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}-${var.env}"
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
  tags   = var.tags
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE"]
    allowed_origins = [aws_cloudfront_distribution.s3_distribution.domain_name]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl = var.acl
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.versioning
  }
}


data "aws_route53_zone" "domain_name" {
  count        = var.use_default_domain ? 0 : 1
  zone_id = var.zonid
  private_zone = false
}

resource "aws_route53_record" "route53_record" {
  name   = var.domain_name
  zone_id = data.aws_route53_zone.domain_name[0].zone_id
  type    = "A"
  alias {
    name   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }

}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [
    aws_s3_bucket.s3_bucket
  ]

  origin {
    domain_name = "${var.bucket_name}-${var.env}.s3.amazonaws.com"
    origin_id   = "${var.bucket_name}-${var.env}.s3.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = ""

  aliases = local.domain_name

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = "${var.bucket_name}-${var.env}.s3.amazonaws.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  
    min_ttl                = var.cloudfront_min_ttl
    default_ttl            = var.cloudfront_default_ttl
    max_ttl                = var.cloudfront_max_ttl
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.restrict_type
    }
  }
  dynamic "viewer_certificate" {
    for_each = local.default_certs
    content {
      cloudfront_default_certificate = true
    }
  }

  dynamic "viewer_certificate" {
    for_each = local.acm_certs
    content {
      acm_certificate_arn      = var.acm_certificate 
      ssl_support_method       = var.ssl_supportmethod
      minimum_protocol_version = var.minimum_protocol
    }
  }

  custom_error_response {
    error_code            = var.error_code
    response_code         = var.response_code
    error_caching_min_ttl = var.error_caching
    response_page_path    = "/index.html"
  }

  wait_for_deployment = false
  tags                = var.tags
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.domain_name}.s3.amazonaws.com"
}
