provider "aws" {
  region = var.region
}

# Use the existing VPC by ID
data "aws_vpc" "default" {
  id = "vpc-067449f8314d4e6c0"
}

# Find the default subnet within that VPC
data "aws_subnet" "default" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }

  filter {
    name   = "vpc-id"
    values = ["vpc-067449f8314d4e6c0"]
  }
}

# Security group for SSH, HTTP, and Node Exporter
resource "aws_security_group" "ssh_http" {
  name        = "allow_ssh_http2"
  description = "Allow SSH, HTTP, and Node Exporter"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance using existing VPC + subnet
resource "aws_instance" "web" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.ssh_http.id]
  associate_public_ip_address = true

  tags = {
    Name = "test1"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/hosts_ip.txt"
  }
}
