variable "username" {
    type = string
}

variable "aws_prometheus_workspace" {
    type = string
}

variable "account_access_type" {
    type = string
    default = "CURRENT_ACCOUNT"
}

variable "authentication_providers" {
    type = list(string)
    default = ["AWS_SSO"]
}

variable "permission_type" {
    type = string
    default = "CUTOMER_MANAGED"
}

variable "data_sources" {
    type = list(string)
}

variable "grafana_workspacename" {
    type = string
}

variable "key_name" {
    type = string
}

variable "key_role" {
    type = string
}

variable "idp_url" {
    type = string
}

