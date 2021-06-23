data "aws_ami" "amzn-ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-*-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = [
    "hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "alpha" {
  ami           = data.aws_ami.amzn-ami.image_id
  instance_type = "t2.micro"
  tags = {
    Name    = "Quickstart-alpha"
    Purpose = "Education"
  }
}