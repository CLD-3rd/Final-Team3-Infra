########################################
# CloudFront 캐시 및 오리진 요청 정책 (AWS Managed)
########################################
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}
data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled" # API 요청 캐싱 비활성화
}
data "aws_cloudfront_origin_request_policy" "cors_s3_origin" {
  name = "Managed-CORS-S3Origin"
}
data "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "Managed-SecurityHeadersPolicy" # HSTS, CSP 등 보안 헤더
}

########################################
# Origin Access Control (CloudFront → S3)
########################################
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.service_name}-s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

########################################
# CloudFront Distribution (두 오리진)
########################################
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "CloudFront for ${var.domain_name}"
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.domain_name]

  # 오리진 #1: S3 버킷 (정적 프론트엔드)
  origin {
    domain_name              = var.s3_origin_domain   # ex) your-bucket.s3.amazonaws.com
    origin_id                = "S3-${var.service_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  # 오리진 #2: NLB (백엔드 API)
  origin {
    domain_name = aws_lb.eks_nlb.dns_name  # ex) your-nlb-xxxx.elb.amazonaws.com
    origin_id   = "NLB-${var.service_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"    # NLB는 HTTP로 받는 경우 많음
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  ########################################
  # 기본 캐시 동작 (정적 콘텐츠 - S3)
  ########################################
  default_cache_behavior {
    target_origin_id           = "S3-${var.service_name}"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_optimized.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.cors_s3_origin.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id
  }

  ########################################
  # 추가 캐시 동작 (API: 캐싱 비활성화 - NLB)
  ########################################
  ordered_cache_behavior {
    path_pattern               = "/api/*"
    target_origin_id           = "NLB-${var.service_name}"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "DELETE", "PATCH"]
    cached_methods             = ["GET", "HEAD"]
    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.cors_s3_origin.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id
  }

  ########################################
  # 커스텀 에러 페이지 (SPA 라우팅 대응)
  ########################################
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code         = custom_error_response.value.error_code
      response_code      = custom_error_response.value.response_code
      response_page_path = custom_error_response.value.response_page_path
    }
  }

  logging_config {
    include_cookies = false
    bucket          = "${var.cloudfront_log_bucket_name}.s3.amazonaws.com"
    prefix          = "cloudfront-logs/"
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  lifecycle {
    ignore_changes = all
  }

  tags = var.tags
}

########################################
# S3 버킷 정책 (CloudFront OAC 전용)
########################################
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "oac_policy" {
  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}
