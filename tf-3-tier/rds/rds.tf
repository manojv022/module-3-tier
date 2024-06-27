resource "aws_db_subnet_group" "db-subnet-group" {
  name = var.rds_subnet_group
  subnet_ids = [ var.subnet_2, var.subnet_3 ]
}
 
resource "aws_db_instance" "rds" {
  allocated_storage = var.allow_storage
  db_name = var.db_name
  engine = var.engine
  engine_version = var.engine_version
  username = var.admin
  password = var.passwd
  instance_class = var.instance_class
  skip_final_snapshot = var.snapshot
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name

  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = var.rds_name
  }
}
