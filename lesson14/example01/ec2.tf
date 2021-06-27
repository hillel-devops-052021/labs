resource "aws_instance" "srv" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count         = var.instance_count
  tags          = var.tags
  key_name      = "aws_hillel"
  # aws ec2 create-key-pair --key-name aws_hillel --query 'KeyMaterial' --output text > aws_hillel.pem


  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install wget curl vim -y"
    ]
    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/aws_hillel.pem")
        host        = aws_instance.srv[count.index].public_ip
    }
  }
}
