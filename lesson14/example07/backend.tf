terraform {
  backend "s3" {
    bucket = "ithillelremotestate001"
    key = "dev/ec2"
  }
}