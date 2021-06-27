# AWS parameters
/*
variable "aws_access_key" {
    default = " ... " # export AWS_ACCESS_KEY_ID=AK...
}

variable "aws_secret_key" {
    default = " ... " # export AWS_SECRET_ACCESS_KEY=Dh9d...
}

variable "aws_region" {
    default = " ... " # export AWS_REFAULT_REGION=us-east-1
}
*/

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
