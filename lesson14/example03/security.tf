data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow 80 and 443 inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "tcp_80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    description      = "tcp_443"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.default.cidr_block]
  }

    ingress {
    description      = "tcp_22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["213.231.49.172/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web"
  }
}
