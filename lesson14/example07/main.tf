provider "aws" {
  region = "us-east-1"
}

module "elb" {
  source = "../modules/elb"
  instance_type = "${var.instance_type}"
  instance_count = "${var.instance_count}"
  tags = "${var.tags}"
}