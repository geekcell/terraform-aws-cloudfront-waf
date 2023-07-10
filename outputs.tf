output "arn" {
  description = "The ARN of the ACL."
  value       = aws_wafv2_web_acl.main.arn
}
