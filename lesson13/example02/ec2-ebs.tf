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