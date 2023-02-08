
output "prod_public_subnet_ids" {
  value = module.vpc-prod.public_subnet_ids
}


output "prod_vpc_id" {
  value = module.vpc-prod.vpc_id
}

output "prod_route_table_id" {
  value = module.vpc-prod.route_table_id
}

output "prod_vpc_cidr" {
  value = module.vpc-prod.vpc_cidr
}


