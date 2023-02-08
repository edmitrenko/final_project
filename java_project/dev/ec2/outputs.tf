output "dev-tomcat_id" {
  description = "The ID of the instance"
  value       = module.dev-tomcat.id
}

output "dev-tomcat_arn" {
  description = "The ARN of the instance"
  value       = module.dev-tomcat.arn
}

output "dev-tomcat_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.dev-tomcat.public_ip
}

output "dev-tomcat_private_ip" {
  description = "The private IP address assigned to the instance."
  value       = module.dev-tomcat.private_ip
}

################################################################

output "dev-jenkins_id" {
  description = "The ID of the instance"
  value       = module.dev-jenkins.id
}

output "dev-jenkins_arn" {
  description = "The ARN of the instance"
  value       = module.dev-jenkins.arn
}

output "dev-jenkins_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.dev-jenkins.public_ip
}

output "dev-jenkins_private_ip" {
  description = "The private IP address assigned to the instance."
  value       = module.dev-jenkins.private_ip
}
################################################################

output "dev-ansible_id" {
  description = "The ID of the instance"
  value       = module.dev-ansible.id
}

output "dev-ansible_arn" {
  description = "The ARN of the instance"
  value       = module.dev-ansible.arn
}

output "dev-ansible_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.dev-ansible.public_ip
}

output "dev-ansible_private_ip" {
  description = "The private IP address assigned to the instance."
  value       = module.dev-ansible.private_ip
}
