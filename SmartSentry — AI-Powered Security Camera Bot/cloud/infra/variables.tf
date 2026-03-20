variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix applied to every resource name"
  type        = string
  default     = "smartsentry"
}

variable "environment" {
  description = "Deployment environment label (dev / staging / prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "alert_email" {
  description = "Email address that receives SNS alert notifications"
  type        = string
  sensitive   = true
  # No default — must be supplied via terraform.tfvars or -var flag
}

variable "person_confidence_threshold" {
  description = "Minimum Rekognition 'Person' confidence (0–100) required to fire an alert"
  type        = number
  default     = 80

  validation {
    condition     = var.person_confidence_threshold > 0 && var.person_confidence_threshold <= 100
    error_message = "person_confidence_threshold must be between 1 and 100."
  }
}
