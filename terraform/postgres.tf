// POSTGRES
resource "aws_security_group" "postgres" {
  name = "security_group_name"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port   = var.postgres_port
    to_port     = var.postgres_port
    protocol    = "tcp"
    description = "PostgreSQL"
    #cidr_blocks = ["0.0.0.0/0"] // >
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    ipv6_cidr_blocks = [ data.aws_vpc.vpc.ipv6_cidr_block]
  }
}

# resource "aws_db_instance" "postgres" {
#   allocated_storage      = 20
#   storage_type           = "gp2"
#   engine                 = "postgres"
#   engine_version         = "17.4"
#   instance_class         = "db.t2.micro"
#   identifier             = var.postgres_instance_name
#   username               = var.postgres_user_name
#   password               = var.postgres_user_password
#   publicly_accessible    = true
#   parameter_group_name   = "default.postgres17"
#   vpc_security_group_ids = [aws_security_group.postgres.id]
#   skip_final_snapshot    = true
# }

resource "aws_db_subnet_group" "subnet_group" {
  name = "my-db-subnet-group"
  subnet_ids = data.aws_subnets.vpc_subnets.ids
}

resource "aws_rds_cluster" "postgres" {
  #vpc = 
  cluster_identifier      = "${local.resource_prefix}-aurora"
  engine                  = "aurora-postgresql"
  #availability_zones      = local.availability_zone_ids
  availability_zones      = data.aws_availability_zones.available.names
  database_name           = "demo"
  master_username         = var.postgres_user_name
  master_password         = var.postgres_user_password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  deletion_protection       = false  # Change to "true" in production!
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot = true
  vpc_security_group_ids = [ aws_security_group.postgres.id ]
  #final_snapshot_identifier = "${local.resource_prefix}-aurora-DELETE-ME"
  serverlessv2_scaling_configuration {
    max_capacity             = 1.0
    min_capacity             = 0.0
  }
}

resource "aws_rds_cluster_instance" "postgres" {
  cluster_identifier = aws_rds_cluster.postgres.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.postgres.engine
  engine_version     = aws_rds_cluster.postgres.engine_version
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
}

output "postgres_endpoint" {
    value = "${aws_rds_cluster.postgres.endpoint}"
}

output "postgres_user_credentials" {
    value = "${var.postgres_user_name}:${var.postgres_user_password}"
}
