resource "aws_prometheus_workspace" "demo" {
  alias = var.aws_prometheus_workspace

  tags = {
    Environment = "test"
    Owner       = "shubham"
  }
}