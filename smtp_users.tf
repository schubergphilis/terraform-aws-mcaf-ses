// Create IAM users to send mail
module "smtp_users" {
  for_each = toset(var.smtp_users)

  source                   = "github.com/schubergphilis/terraform-aws-mcaf-user?ref=v0.1.12"
  name                     = "${each.key}@${var.domain}"
  policy                   = data.aws_iam_policy_document.allow_iam_user_to_send_emails.json
  postfix                  = false
  ssm_ses_smtp_password_v4 = true
  tags                     = var.tags
}

// tfsec:ignore:AWS099
data "aws_iam_policy_document" "allow_iam_user_to_send_emails" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

// Store credentials in Secrets Manager to be picked up by External Secrets
resource "aws_secretsmanager_secret" "default" {
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
