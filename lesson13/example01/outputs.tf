output "instance_id" {
  value       = aws_instance.alpha.id
  description = "ID of created instance"
}
output "instance_public_ip" {
  value       = aws_instance.alpha.public_ip
  description = "Public IP"
}