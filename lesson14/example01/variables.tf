# AWS parameters
/*
variable "aws_access_key" {
    default = "..." # export AWS_ACCESS_KEY_ID=AKIXXXXXXXXXXXXXXXXX
}

variable "aws_secret_key" {
    default = "..." # export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
}

variable "aws_region" {
    default = "..." # export AWS_DEFAULT_REGION=us-east-1
}
*/

# Instance parameters
variable "instance_type" {
  default = "t2.micro"
}

# Amount of instances
variable "instance_count" {
  default = 1
}

# Tags
variable "tags" {
  type = map(string)

  default = {
    Team    = "hillel_devops"
    Project = "ec2"
  }
}