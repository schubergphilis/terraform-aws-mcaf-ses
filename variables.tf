variable "domain" {
  type        = string
  description = "Domain name"
}

variable "dmarc" {
  type = object({
    policy = optional(string, "v=DMARC1;p=reject;sp=reject")
    rua    = optional(string)
    ruf    = optional(string)
  })
  description = "(Optional) DMARC configuration"
}

variable "mail_from_domain" {
  type        = string
  default     = null
  description = "Set a MAIL FROM domain (defaults to `mail.$domain`)"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ARN used for encryption"
}

variable "smtp_users" {
  type        = list(string)
  default     = []
  description = "List of SMTP users allowed to send mail from this domain"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to set on Terraform created resources"
}
