
output "dev_public_subnet_ids" {
  value = module.vpc-dev.public_subnet_ids
}

output "dev_vpc_id" {
  value = module.vpc-dev.vpc_id
}

output "dev_route_table_id" {
  value = module.vpc-dev.route_table_id
}

output "dev_vpc_cidr" {
  value = module.vpc-dev.vpc_cidr
}

