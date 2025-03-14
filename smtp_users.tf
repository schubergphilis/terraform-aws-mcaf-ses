// Create IAM users to send mail
module "smtp_users" {
  #checkov:skip=CKV_AWS_273: IAM user is the only option for SMTP auth
  for_each = toset(var.smtp_users)

  source  = "schubergphilis/mcaf-user/aws"
  version = "~> 0.4.3"

  name                     = "${each.key}@${var.domain}"
  create_policy            = true
  policy                   = data.aws_iam_policy_document.allow_iam_user_to_send_emails.json
  postfix                  = false
  ssm_ses_smtp_password_v4 = true
  tags                     = var.tags
}

// tfsec:ignore:AWS099
data "aws_iam_policy_document" "allow_iam_user_to_send_emails" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = [replace(aws_ses_domain_identity.default.arn, var.domain, "*")]
  }
}

// Store credentials in Secrets Manager to be picked up by External Secrets
resource "aws_secretsmanager_secret" "default" {
  #checkov:skip=CKV2_AWS_57: Not possible to enable secret rotation for this resource
  for_each = toset(var.smtp_users)

  name       = "ses/${var.domain}/${each.key}"
  kms_key_id = var.kms_key_id
  tags       = var.tags
}

resource "aws_secretsmanager_secret_version" "default" {
  for_each = toset(var.smtp_users)

  secret_id = aws_secretsmanager_secret.default[each.key].id

  secret_string = jsonencode({
    "smtp-username" = module.smtp_users[each.key].access_key_id
    "smtp-password" = module.smtp_users[each.key].ses_smtp_password_v4
  })
}
