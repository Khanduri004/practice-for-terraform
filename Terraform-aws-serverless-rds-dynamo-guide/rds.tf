# KMS key for RDS encryption
resource "aws_kms_key" "rds" {
  description = "KMS key for RDS encryption"
  deletion_window_in_days = 30
  enable_key_rotation = true
  tags = { Name = "${var.prefix}-rds-kms" }
}


# Security group for RDS - only allow traffic from inside the VPC
resource "aws_security_group" "rds_sg" {
  name = "${var.prefix}-rds-sg"
  vpc_id = aws_vpc.main.id
  ingress {
   from_port = 5432
   to_port = 5432
   protocol = "tcp"
   cidr_blocks = [aws_vpc.main.cidr_block]
}


   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# DB subnet group (private subnets)
resource "aws_db_subnet_group" "pg_subnets" {
  name = "${var.prefix}-pg-subnets"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  tags = { Name = "${var.prefix}-pg-subnet-group" }
}


# generate a password (demo use)
resource "random_password" "db" {
  length = 16
  special = true
}


# RDS instance
resource "aws_db_instance" "postgres" {
  identifier = "${var.prefix}-postgres-db"
  allocated_storage = 20
  engine = "postgres"
  engine_version = "15.3"
  instance_class = var.db_instance_class
  username = var.db_username
  password = random_password.db.result
  db_subnet_group_name = aws_db_subnet_group.pg_subnets.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  storage_encrypted = true
  kms_key_id = aws_kms_key.rds.key_id
  backup_retention_period = 7
  backup_window = "03:00-04:00"
  skip_final_snapshot = true # for demo; set to false in production


# explicitly depend on VPC/subnet resources (demonstration of depends_on)
depends_on = [aws_vpc.main, aws_subnet.private_a, aws_subnet.private_b, aws_db_subnet_group.pg_subnets]


tags = { Name = "${var.prefix}-postgres" }
}
