data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["746669221855"]  # The AWS account ID that owns the AMI

  filter {
    name   = "name"
    values = ["ami-version-1.0.1-1739773564"]  # The exact AMI name
  }

  filter {
    name   = "image-id"
    values = ["ami-04d1fdf970c3124a2"]  # The exact AMI ID
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]  # Architecture of the AMI
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]  # Virtualization type
  }
}

resource "aws_iam_role" "example" {
  name = "ag_iam_role_region2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "auto_scaling_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.example.name
}

resource "aws_iam_instance_profile" "example" {
  name = "ag_iam_region2"
  role = aws_iam_role.example.name
}
















# Terraform AWS Launch Template
resource "aws_launch_template" "ec2_asg" {
  name                  = "my-launch-template_region2"
  image_id              = data.aws_ami.amazon_linux_2.id
  instance_type         = "t2.large"
  iam_instance_profile {
    name = "ag_iam_region2"
  }
  user_data = base64encode(templatefile("userdata.sh", { postgress_url = aws_db_instance.db_instance.endpoint }))
  vpc_security_group_ids = [aws_security_group.alb_security_group.id]
  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "asg-tf" {
  name                 = "autoscaling_in_private_region2"
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  force_delete         = true
  depends_on           = [aws_lb.application_load_balancer]
  target_group_arns    = [aws_lb_target_group.alb_target_group.arn]
  health_check_type    = "EC2"
  launch_template {
    id      = aws_launch_template.ec2_asg.id
    version = aws_launch_template.ec2_asg.latest_version
  }
  vpc_zone_identifier  = [aws_subnet.private_sub1.id ,aws_subnet.private_sub2.id ]

  tag {
    key                 = "ag_key"
    value               = "autoscaling_in_private_region2"
    propagate_at_launch = true
  }
}
