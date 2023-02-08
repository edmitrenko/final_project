output "prod-tomcat1_id" {
  description = "The ID of the instance"
  value       = module.prod-tomcat1.id
}

output "prod-tomcat1_arn" {
  description = "The ARN of the instance"
  value       = module.prod-tomcat1.arn
}

output "prod-tomcat1_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.prod-tomcat1.public_ip
}

output "prod-tomcat1_private_ip" {
  description = "The private IP address assigned to the instance."
  value       = module.prod-tomcat1.private_ip
}
#####################################################################

output "prod-tomcat2_id" {
  description = "The ID of the instance"
  value       = module.prod-tomcat2.id
}

output "prod-tomcat2_arn" {
  description = "The ARN of the instance"
  value       = module.prod-tomcat2.arn
}

output "prod-tomcat2_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.prod-tomcat2.public_ip
}

output "prod-tomcat2_private_ip" {
  description = "The private IP address assigned to the instance."
  value       = module.prod-tomcat2.private_ip
}


