provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "TerraformAnsibleVM"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/hosts_ip.txt"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
}

