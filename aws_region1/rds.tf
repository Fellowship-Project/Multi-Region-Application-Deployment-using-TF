# Create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database-security-group-region1"
  description = "Enable Postgress/Aurora access on port 5432"
  vpc_id      = aws_vpc.myvpc.id  # Replace with your VPC ID

  ingress {
    description      = "Postgress/Aurora access"
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
    Name = "database-security-group-region1"
  }
}

# Create the subnet group for the RDS instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "db-secure-subnets-region1"
  subnet_ids  = [aws_subnet.secure_subnet_az1.id,aws_subnet.secure_subnet_az2.id ]  # Replace with your secure subnet IDs
  description = "RDS in secure subnet"

  tags = {
    Name = "db-secure-subnets-region1"
  }
}

#data "aws_db_instance" "db_instance_data" {   
 # endpoint = aws_db_instance.db_instance.endpoint
#} 

resource "aws_db_parameter_group" "log_db_parameter" {
  name   = "logs-region1"
  family = "postgres16"

  parameter {
    value = "1"
    name  = "log_connections"
  }

  tags = {
    env = "logs-region1"
  }
}












# Create the RDS instance
resource "aws_db_instance" "db_instance" {
  engine                = "postgres"
  engine_version        = "16.3"
  multi_az              = true
  parameter_group_name    = aws_db_parameter_group.log_db_parameter.name
  identifier            = "openproject-region1"
  username              = "openproject"
  password              = "openproject"
  instance_class        = "db.t3.medium"
  allocated_storage     = 50
  publicly_accessible   = true
  db_subnet_group_name  = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  db_name               = "openproject"
  skip_final_snapshot   = true
}

#data "aws_db_instance" "db_instance_data" {   
 # endpoint = aws_db_instance.db_instance.endpoint
#} 



