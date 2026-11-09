
output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion server"
  value       = aws_eip.bastion.public_ip
}

output "backend_private_ip" {
  description = "Private IP address of the backend server"
  value       = aws_instance.backend.private_ip
}

output "mongodb_private_ip" {
  description = "Private IP address of the MongoDB server"
  value       = aws_instance.mongodb.private_ip
}
