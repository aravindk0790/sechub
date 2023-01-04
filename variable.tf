variable "name" {
  description = "name of the SNS topic"
  type        = string
  default     = "SecurityHubRecurringSummary"
}

variable "email" {
  description = "Email Address for Subscriber to Security Hub summary"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS Key ID to use for encrypting the topic"
  type        = string
  default     = "alias/aws/sns"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "custominsights_lambda_name" {
  description = "name of the lambda for Custom Insights"
  type        = string
  default     = "CustomInsightsFunction"
}

variable "schedule" {
  description = "Expression for scheduling the Security Hub summary email"
  type        = string
  default     = "cron(0 8 ? * 2 *)"
}

variable "sechub_lambda_name" {
  description = "name of the lambda for SendSecurityHubSummaryEmail"
  type        = string
  default     = "SendSecurityHubSummaryEmail"
}

variable "additional_email_footer_text" {
  description = "Additional text to append at the end of email message"
  type        = string
  default     = ""
}