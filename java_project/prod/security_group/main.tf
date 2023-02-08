provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket where to SAVE Terraform State
    key        = "prod/sg/terraform.tfstate"                    // Object name in the bucket to SAVE Terraform State
    region     = "eu-central-1"                                 // Region where bycket created
   }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket from where to GET Terraform State
    key        = "prod/network/terraform.tfstate"               // Object name in the bucket to GET Terraform state
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
  name                    = "prod-80-tcp"
  vpc_id                  = data.terraform_remote_state.network.outputs.prod_vpc_id
  allow_ports             = ["80"]
  protocol                = "tcp"
  env                     = "prod"
  project                 = "EPAM_Final_Project"  
  owner                   = "Evgeniy Dmitrenko"
}

module "prod-tomcat" {
  source                  = "github.com/edmitrenko/terraform_modules/aws_security_group"
  name                    = "prod-tomcat"
  vpc_id                  = data.terraform_remote_state.network.outputs.prod_vpc_id
  allow_ports             = ["8080", "8081", "8082"]
  protocol                = "tcp"
  env                     = "prod"
  project                 = "EPAM_Final_Project"
  owner                   = "Evgeniy Dmitrenko"    
}

module "tcp-22" {
  source                  = "github.com/edmitrenko/terraform_modules/aws_security_group"
  name                    = "prod-22-tcp"
  vpc_id                  = data.terraform_remote_state.network.outputs.prod_vpc_id
  allow_ports             = ["22"]
  protocol                = "tcp" 
  env                     = "prod"
  project                 = "EPAM_Final_Project"
  owner                   = "Evgeniy Dmitrenko"   
}

module "tcp-3306" {
  source                  = "github.com/edmitrenko/terraform_modules/aws_security_group"
  name                    = "prod-3306-tcp"
  vpc_id                  = data.terraform_remote_state.network.outputs.prod_vpc_id
  allow_ports             = ["3306"]
  protocol                = "tcp" 
  env                     = "prod"
  project                 = "EPAM_Final_Project"
  owner                   = "Evgeniy Dmitrenko"   
}

module "all-icmp" {
  source                  = "github.com/edmitrenko/terraform_modules/aws_security_group"
  name                    = "prod-all-icmp"
  vpc_id                  = data.terraform_remote_state.network.outputs.prod_vpc_id
  allow_ports             = ["-1"]
  protocol                = "icmp" 
  env                     = "prod"
  project                 = "EPAM_Final_Project"
  owner                   = "Evgeniy Dmitrenko"   
}

