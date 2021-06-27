terraform {
  backend "s3" {
    bucket = "ithillelremotestate001"
    key = "dev/ec2"
  }
}

resource "aws_instance" "srv" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count         = var.instance_count
  tags          = var.tags
  key_name      = "aws_hillel"
  # aws ec2 create-key-pair --key-name aws_hillel --query 'KeyMaterial' --output text > aws_hillel.pem
  vpc_security_group_ids = [aws_security_group.web.id]
}

resource "aws_elb" "elb" {
  name = "ec2elb"
  availability_zones = aws_instance.srv[*].availability_zone

  dynamic "listener" {
    for_each = ["80","443"]
    content {
      instance_port = listener.value
      instance_protocol = "http"
      lb_port = listener.value
      lb_protocol = "http"
    }
  }

  health_check {
    healthy_threshold =  2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:22"
    interval = 30
  }

  instances                   = aws_instance.srv[*].id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }

}
