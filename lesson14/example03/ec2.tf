resource "aws_instance" "srv" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count         = var.instance_count
  tags          = var.tags
  key_name      = "aws_hillel"
  # aws ec2 create-key-pair --key-name aws_hillel --query 'KeyMaterial' --output text > aws_hillel.pem
  vpc_security_group_ids = [aws_security_group.web.id]
}
