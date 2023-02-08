output "security_group_id_80-tcp" {
  description = "The ID of the security group http-80-tcp"
  value       = module.tcp-80.security_group_id
}


output "security_group_id_22-tcp" {
  description = "The ID of the security group"
  value       = module.tcp-22.security_group_id
}

output "security_group_id_8080-tcp" {
  description = "The ID of the security group"
  value       = module.tcp-8080.security_group_id
}

output "security_group_id_all-icmp" {
  description = "The ID of the security group"
  value       = module.all-icmp.security_group_id
}
