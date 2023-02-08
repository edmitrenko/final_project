provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket where to SAVE Terraform State
    key        = "dev/sg/terraform.tfstate"                     // Object name in the bucket to SAVE Terraform State
    region     = "eu-central-1"                                 // Region where bycket created
   }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket from where to GET Terraform State
    key        = "dev/network/terraform.tfstate"                // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                 // Region where bycket created
    }
}


#----------------------------------------------------------
# Use Our Terraform Module to create AWS Security Groups
#----------------------------------------------------------

data "aws_vpc" "vpc" {
  default = true
}

module "tcp-80" {
  source                  = "github.com/edmitrenko/terraform_modules/aws_security_group"
  name                    = "dev-80-tcp"
  vpc_id                  = data.terraform_remote_state.network.outputs.dev_vpc_id
  allow_ports             = ["80"]
  protocol                = "tcp"
  env                     = "dev"
  project                 = "EPAM_Final_Project"  
  owner                   = "Evgeniy Dmitrenko"
}

module "tcp-22" {
  source                  = "github.com/edmitrenko/terraform_modules/aws_security_group"
  name                    = "dev-22-tcp"
  vpc_id                  = data.terraform_remote_state.network.outputs.dev_vpc_id
  allow_ports             = ["22"]
  protocol                = "tcp" 
  env                     = "dev"
  project                 = "EPAM_Final_Project"   
  owner                   = "Evgeniy Dmitrenko"
}

module "tcp-8080" {
  source                  = "github.com/edmitrenko/terraform_modules/aws_security_group"
  name                    = "dev-8080-tcp"
  vpc_id                  = data.terraform_remote_state.network.outputs.dev_vpc_id
  allow_ports             = ["8080"]
  protocol                = "tcp" 
  env                     = "dev"
  project                 = "EPAM_Final_Project"
  owner                   = "Evgeniy Dmitrenko"   
}

module "all-icmp" {
  source                  = "github.com/edmitrenko/terraform_modules/aws_security_group"
  name                    = "dev-all-icmp"
  vpc_id                  = data.terraform_remote_state.network.outputs.dev_vpc_id
  allow_ports             = ["-1"]
  protocol                = "icmp" 
  env                     = "dev"
  project                 = "EPAM_Final_Project"
  owner                   = "Evgeniy Dmitrenko"   
}
