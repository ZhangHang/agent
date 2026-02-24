resource "aws_iam_role" "{{SERVICE}}-{{APP}}-sa" {
  name = "{{SERVICE}}-{{APP}}-sa"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "{{OIDC_PROVIDER_PATH}}:aud" = "sts.amazonaws.com"
              "{{OIDC_PROVIDER_PATH}}:sub" = "system:serviceaccount:{{NAMESPACE}}:{{SERVICE}}-{{APP}}-sa"
            }
          }
          Effect = "Allow"
          Principal = {
            Federated = "{{OIDC_PROVIDER_ARN}}"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = module.{{ENV}}.tags
}

# add policy resources and attachments as needed by real dependencies
