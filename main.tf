terraform {
  required_version = "~> 0.12"
  backend "local" {}
}

provider "aws" {
  region  = var.aws_region
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  owners = ["amazon"]
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "key-dl"
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "pem" {
  filename        = "${aws_key_pair.generated_key.key_name}.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "400"
}

resource "aws_security_group" "jupyter" {
  name        = "jupyter-sg"
  description = "Security group for jupyter"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "jupyter"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "jupyter-sg"
    ManagedBy   = "terraform"
    Stack       = "AWS Deep Learning instance with Jupyter"
  }
}

resource "aws_instance" "jupyter" {
  ami                    = data.aws_ami.ami.id
  availability_zone      = var.availability_zone
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.jupyter.id]

  connection {
    type        = "ssh"
    host        = self.public_dns
    port        = "22"
    user        = "ubuntu"
    private_key = file("${aws_key_pair.generated_key.key_name}.pem")
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
      "jupyter notebook --NotebookApp.token='' --no-browser &",
      "sleep 300"
    ]
  }

  tags = {
    Name        = "jupyter"
    ManagedBy   = "terraform"
    Stack       = "AWS Deep Learning instance with Jupyter"
  }

  volume_tags = {
    Name        = "jupyter_ROOT"
    ManagedBy   = "terraform"
    Stack       = "AWS Deep Learning instance with Jupyter"
  }
}
