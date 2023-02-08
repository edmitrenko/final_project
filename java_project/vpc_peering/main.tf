provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket where to SAVE Terraform State
    key        = "vpc_peering/terraform.tfstate"                // Object name in the bucket to SAVE Terraform State
    region     = "eu-central-1"                                 // Region where bycket created
   }
}
#======================================================================================================================


data "terraform_remote_state" "network_dev" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "dev/network/terraform.tfstate"                 // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}


data "terraform_remote_state" "network_prod" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "prod/network/terraform.tfstate"                // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}

#======================================================================================================================

resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id   = data.terraform_remote_state.network_dev.outputs.dev_vpc_id
  vpc_id        = data.terraform_remote_state.network_prod.outputs.prod_vpc_id
  auto_accept   = true
  
  tags = {
    Name = "VPC Peering between dev and prod"
  }
}

resource "aws_route" "dev_route" {
  route_table_id            = data.terraform_remote_state.network_dev.outputs.dev_route_table_id 
  destination_cidr_block    = data.terraform_remote_state.network_prod.outputs.prod_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "prod_route" {
  route_table_id            = data.terraform_remote_state.network_prod.outputs.prod_route_table_id 
  destination_cidr_block    = data.terraform_remote_state.network_dev.outputs.dev_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}