output "ids" {
  description = "List of IDs of instances"
  value       = module.ec2_jenkins.id
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances"
  value       = module.ec2_jenkins.public_dns
}

output "vpc_security_group_ids" {
  description = "List of VPC security group ids assigned to the instances"
  value       = module.ec2_jenkins.vpc_security_group_ids
}

output "root_block_device_volume_ids" {
  description = "List of volume IDs of root block devices of instances"
  value       = module.ec2_jenkins.root_block_device_volume_ids
}

output "tags" {
  description = "List of tags"
  value       = module.ec2_jenkins.tags
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2_jenkins.id[0]
}

output "instance_public_dns" {
  description = "Public DNS name assigned to the EC2 instance"
  value       = module.ec2_jenkins.public_dns[0]
}

output "instance_public_ip" {
  description = "Public DNS name assigned to the EC2 instance"
  value       = resource.aws_eip.this.public_ip
}