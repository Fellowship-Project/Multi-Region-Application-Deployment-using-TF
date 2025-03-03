# Create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database-security-group-region2"
  description = "Enable PostgreSQL/Aurora access on port 5432"
  vpc_id      = aws_vpc.myvpc.id  # Replace with your VPC ID
  
  ingress {
    description      = "PostgreSQL/Aurora access"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]  
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "database-security-group-region2"
  }
}

# Create the subnet group for the Aurora cluster
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "db-secure-subnets-region2"
  subnet_ids  = [aws_subnet.secure_subnet_az1.id, aws_subnet.secure_subnet_az2.id]  # Replace with your secure subnet IDs
  description = "Aurora cluster in secure subnet"
  
  tags = {
    Name = "db-secure-subnets-region2"
  }
}

# Create parameter group for Aurora PostgreSQL
resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group" {
  name        = "aurora-pg16-cluster-params-region2"
  family      = "aurora-postgresql16"
  description = "Aurora PostgreSQL cluster parameter group"
  
  parameter {
    name  = "log_connections"
    value = "1"
  }
  
  tags = {
    Name = "aurora-pg16-cluster-params-region2"
    env  = "logs-region2"
  }
}

resource "aws_db_parameter_group" "aurora_db_parameter_group" {
  name        = "aurora-pg16-instance-params-region2"
  family      = "aurora-postgresql16"
  description = "Aurora PostgreSQL instance parameter group"
  
  parameter {
    name  = "log_statement"
    value = "ddl"
  }
  
  tags = {
    Name = "aurora-pg16-instance-params-region2"
    env  = "logs-region1"
  }
}

# Create the Aurora PostgreSQL cluster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "openproject-aurora-region2"
  engine                  = "aurora-postgresql"
  engine_version          = "16.3"
  database_name           = "openproject"
  master_username         = "openproject"
  master_password         = "openproject"
  backup_retention_period = 7
  preferred_backup_window = "02:00-03:00"
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database_security_group.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group.name
  skip_final_snapshot     = true
  storage_encrypted       = true
  
  lifecycle {
    ignore_changes = [master_password]
  }
  
  tags = {
    Name = "openproject-aurora-region2"
  }
}

# Create the Aurora primary instance
resource "aws_rds_cluster_instance" "aurora_primary" {
  identifier           = "openproject-aurora-primary-region2"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = "db.t3.medium"
  engine               = "aurora-postgresql"
  engine_version       = "16.3"
  db_parameter_group_name = aws_db_parameter_group.aurora_db_parameter_group.name
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  publicly_accessible  = false  # Set to false for security
  
  tags = {
    Name = "openproject-aurora-primary-region2"
  }
}

# Create the Aurora read replica
resource "aws_rds_cluster_instance" "aurora_replica" {
  identifier           = "openproject-aurora-replica-region2"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = "db.t3.medium"
  engine               = "aurora-postgresql"
  engine_version       = "16.3"
  db_parameter_group_name = aws_db_parameter_group.aurora_db_parameter_group.name
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  publicly_accessible  = false  # Set to false for security
  
  tags = {
    Name = "openproject-aurora-replica-region2"
  }
}

# Output the cluster endpoint (writer endpoint)
output "aurora_cluster_endpoint" {
  description = "The cluster endpoint for the Aurora PostgreSQL cluster"
  value       = aws_rds_cluster.aurora_cluster.endpoint
}

# Output the cluster reader endpoint (for read replica)
output "aurora_reader_endpoint" {
  description = "The reader endpoint for the Aurora PostgreSQL cluster"
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
}
