#----------------------------------------------------------
# Use Our Terraform Module to create AWS VPC Networks
#----------------------------------------------------------
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket where to SAVE Terraform State
    key        = "prod/network/terraform.tfstate"                // Object name in the bucket to SAVE Terraform State
    region     = "eu-central-1"                                 // Region where bycket created
   }
}


module "vpc-prod" {
  source               = "github.com/edmitrenko/terraform_modules/aws_network"
  env                  = "prod"
  vpc_name             = "vpc-prod"
  ig_name              = "ig-prod"
  subnet_name          = "subnet-prod"
  rt_name              = "rt-prod"
  project              = "EPAM_Final_Project"
  vpc_cidr             = "10.30.0.0/16"
  public_subnet_cidrs  = ["10.30.1.0/24", "10.30.2.0/24"]
  owner                = "Evgeniy Dmitrenko"
}


