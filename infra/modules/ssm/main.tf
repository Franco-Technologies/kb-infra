# aws ssm module definition for storing variables outputs from the modules

resource "aws_ssm_parameter" "outputs" {
  name  = var.param_name
  type  = "String"
  value = jsonencode(var.outputs)
}
