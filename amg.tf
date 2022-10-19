resource "aws_grafana_workspace" "example" {
  account_access_type      = var.account_access_type
  authentication_providers = var.authentication_providers
  permission_type          = var.permission_type
  role_arn                 = aws_iam_role.role.arn
  data_sources             = var.data_sources
  #name                     = var.grafana_workspacename
  tags    = {
    Name = var.grafana_workspacename
  }
}

resource "aws_grafana_role_association" "grafana-role" {
  role         = var.key_role
  user_ids     = [data.aws_identitystore_user.user.id]
  workspace_id = aws_grafana_workspace.example.id
}

/*resource "aws_grafana_workspace_saml_configuration" "example" {
  editor_role_values = ["admin"]
  idp_metadata_url   = var.idp_url
  workspace_id       = aws_grafana_workspace.example.id
  role_assertion     = "department"
  admin_role_values  = ["sde"] 
}*/

resource "aws_grafana_workspace_api_key" "key" {
  key_name        = var.key_name
  key_role        = var.key_role
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.example.id
}

resource "aws_iam_role" "AMGPrometheusDataSource-role" {
  name = "AMGWorkspaceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "AMGPrometheusDataSource-policy" {
  name        = "AMGPrometheusDataSourcePolicy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0",
        Action = "sts:AssumeRole",
        Effect   = "Allow",
        Resource = [
          "arn:aws:iam::${var.account_id[0]}:role/AMGPrometheusDataSourceRole-Development",
          "arn:aws:iam::${var.account_id[0]}:role/AMGCloudWatchDataSourceRole-Development",
          "arn:aws:iam::${var.account_id[1]}:role/AMGCloudWatchDataSourceRole-Distinct",
        ]
      },
    ]
  })
}

##Policy attachment######

resource "aws_iam_policy_attachment" "AMGPrometheusDataSource-policyattachment" {
  name       = "AMGPrometheusDataSource-policyattachment"
  roles      = [aws_iam_policy.AMGPrometheusDataSource-role.name]
  policy_arn = aws_iam_policy.AMGPrometheusDataSource-policy.arn
}


output "namespace" {
  value = aws_grafana_workspace.example.name
}