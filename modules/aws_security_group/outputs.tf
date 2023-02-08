output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.id
}

output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = aws_security_group.this.vpc_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.this.name
}
