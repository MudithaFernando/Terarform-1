output "instance_ids" {
  description = "IDs der erstellten EC2-Instances"
  value       = aws_instance.web[*].id
}

output "public_ips" {
  description = "Öffentliche IP-Adressen der EC2-Instances"
  value       = aws_instance.web[*].public_ip
}