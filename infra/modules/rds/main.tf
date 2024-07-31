resource "aws_db_instance" "main" {
  identifier           = "${var.env}-tenant-management-db"
  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  storage_type         = "gp2"
  username             = var.db_username
  password             = var.db_password
  db_name              = "${var.env}_tenant_management"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true

  db_subnet_group_name = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-tenant-management-db-subnet-group"
  subnet_ids = var.subnet_ids
}

# Add security group for RDS
