variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "The Google Cloud region."
  default     = "us-central1"
}

variable "discord_webhook_url" {
  description = "The Discord webhook URL to send notifications."
  type        = string
}

variable "numerai_public_id" {
  description = "Numerai public ID."
  type        = string
}

variable "numerai_secret_key" {
  description = "Numerai secret key."
  type        = string
}

variable "numerai_model_id" {
  description = "Numerai model ID."
  type        = string
}