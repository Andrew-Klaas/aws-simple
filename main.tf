provider "aws" {
	region = "${var.region}"
}

resource "aws_instance" "test" {
  ami = "${var.ami}"
  instance_type = "t2.micro" // t2.micro m4.largem
  count = "1"
  tags {
    Name = "aklaas-TFE-test"
    "billing-id" = "asdf3835"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "private_network_access" {
  name        = "private_network_access"
  description = "security group for private network access"
  vpc_id      = "${data.aws_vpc.default.id}"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
    #cidr_blocks = ["0.0.0.0./0"]

  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
