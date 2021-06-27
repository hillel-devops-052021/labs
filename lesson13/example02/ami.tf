---------- ami.tf
data "aws_ami" "ubuntu" {
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
--------------ec2-ebs.tf
resource "aws_instance" "srv" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count         = var.instance_count
  tags          = var.tags
}

resource "aws_ebs_volume" "ec2_ebs" {
  availability_zone = aws_instance.srv[count.index].availability_zone
  type              = "gp2"
  size              = 100
  count             = var.instance_count
}

resource "aws_volume_attachment" "ec2_ebs_attach" {
  device_name = "/dev/xvdb"
  instance_id = aws_instance.srv[count.index].id
  volume_id   = aws_ebs_volume.ec2_ebs[count.index].id
  count       = var.instance_count
}
--------  outputs.tf
output "instance_id" {
  value       = aws_instance.srv.*.id
  description = "ID of created instance"
}
output "instance_public_ip" {
  value       = aws_instance.srv.*.public_ip
  description = "Public IP"
}
----- variables.tf
# Instance parameters
variable "instance_type" {
  default = "t2.micro"
}

variable "instance_count" {
  default = 1
}

# Tags
variable "tags" {
  type = map(string)

  default = {
    Team    = "Hillel_DevOps"
    project = "ec2"
  }
}
