provider "aws" {
	region = "${var.region}"
}

resource "aws_instance" "test" {
  ami = "${var.ami}"
  instance_type = "t2.small" //t2.micro t2.small
  count = "2"
}
