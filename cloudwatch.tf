module "cloudwatch_log_group" {
  source  = "geekcell/cloudwatch-log-group/aws"
  version = ">= 1.0.1, < 2.0.0"

  name = "aws-waf-logs-${var.name}"
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  log_destination_configs = [module.cloudwatch_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn
}

resource "aws_cloudwatch_log_resource_policy" "main" {
  policy_document = data.aws_iam_policy_document.main.json
  policy_name     = "aws-waf-logs-policy-${var.name}"
}

data "aws_iam_policy_document" "main" {
  version = "2012-10-17"
  statement {

    effect = "Allow"

    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }

    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${module.cloudwatch_log_group.arn}:*"]

    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }

    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
