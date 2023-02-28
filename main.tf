terraform {
  backend "remote" {
    organization = "aklaas_v2"
    //hostname = "Your TFE address"
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
  region = "us-east-2"
}
provider "hcp" {}

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

data "hcp_packer_iteration" "ubuntu" {
  bucket_name = "learn-packer-ubuntu"
  channel     = "production"
}

data "hcp_packer_image" "ubuntu_us_east_2" {
  bucket_name    = "learn-packer-ubuntu"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.ubuntu.ulid
  region         = "us-east-2"
}

resource "aws_instance" "my_ec2" {
  ami           = ata.hcp_packer_image.ubuntu_us_east_2.cloud_image_id
  instance_type = "t2.micro"

  tags = {
    Name = "${var.prefix}-tf-demo"
    billing-id = "1234"
  }
}
