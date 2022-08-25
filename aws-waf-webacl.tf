resource "aws_wafv2_ip_set" "white_list_ip_list" {
  name               = "waf-ddos-tr"
  description        = "white ip set"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["112.221.225.165/32"] 
}

resource "aws_wafv2_web_acl" "example" {
  name  = "waf-ddos-tr-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "waf-ddos-tr-rule"
    priority = 1
    action {
      block {}
    }


    statement {
      rate_based_statement {
        limit              = 2000 
        aggregate_key_type = "IP"
        scope_down_statement {
          not_statement {
            statement { 
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.white_list_ip_list.arn
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-ddos-tr"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}
