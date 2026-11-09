# Retrieve the latest Amazon Linux 2 AMI
data "aws_ssm_parameter" "amazon_linux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public["public_a"].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-bastion"
  }
}

# Elastic IP for Bastion Host
resource "aws_eip" "bastion" {
  domain   = "vpc"
  instance = aws_instance.bastion.id

  tags = {
    Name = "${var.project_name}-bastion-eip"
  }
}

# Backend Server
resource "aws_instance" "backend" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private["private_a"].id
  vpc_security_group_ids = [aws_security_group.backend.id]
  user_data              = file("${path.module}/user_data/backend_setup.sh")

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size           = 12
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-backend"
  }
}

# MongoDB Server
resource "aws_instance" "mongodb" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private["private_b"].id
  vpc_security_group_ids = [aws_security_group.mongodb.id]
  user_data              = file("${path.module}/user_data/mongodb_setup.sh")

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size           = 12
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-mongodb"
  }
}