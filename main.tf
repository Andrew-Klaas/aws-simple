terraform {
  backend "remote" {
    organization = "aklaas_v2"
    workspaces {
      name = "aws-simple"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "${var.prefix}-tf-demo"
    billing-id = "1234"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "${var.prefix}-tf-demo"
    billing-id = "1234"
  }
}

resource "aws_network_interface" "my_nic" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "${var.prefix}-tf-demo"
    billing-id = "1234"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.ubuntu.id # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "${var.prefix}-tf-demo"
    billing-id = "1234"
  }
}
