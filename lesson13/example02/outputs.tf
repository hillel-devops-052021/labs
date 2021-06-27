output "instance_id" {
  value       = aws_instance.srv.*.id
  description = "ID of created instance"
}
output "instance_public_ip" {
  value       = aws_instance.srv.*.public_ip
  description = "Public IP"
}