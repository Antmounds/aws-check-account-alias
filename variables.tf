variable "app_name" {
  type        = string
  default     = "check-account-alias"
  description = "Name of this lambda function."
}

variable "goal_account_alias" {
  type        = string
  default     = ""
  description = "The account alias that is desired."
}

variable "owner" {
  type        = string
  default     = ""
  description = "Email of service owner in case of notifications."
}

variable "notification_number" {
  type        = string
  default     = ""
  description = "The number to send an SMS to on success."
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region to create everything in."
}