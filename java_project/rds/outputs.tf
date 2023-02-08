output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.db_instance_address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.db_instance_endpoint
}

output "db_instance_arn" {
  description = "The address of the RDS instance"
  value       = module.db.db_instance_arn
}

output "db_instance_port" {
  description = "The database port"
  value       = module.db.db_instance_port
}

output "db_instance_name" {
  description = "The database name"
  value       = module.db.db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = nonsensitive(module.db.db_instance_username)
}

output "db_instance_password" {
  value     = nonsensitive(data.aws_ssm_parameter.my_rds_password.value)
}