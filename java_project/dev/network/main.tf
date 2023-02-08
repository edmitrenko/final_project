#----------------------------------------------------------
# Use Our Terraform Module to create AWS VPC Networks
#----------------------------------------------------------
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket where to SAVE Terraform State
    key        = "dev/network/terraform.tfstate"                 // Object name in the bucket to SAVE Terraform State
    region     = "eu-central-1"                                  // Region where bycket created
  }
}


module "vpc-dev" {
  source               = "github.com/edmitrenko/terraform_modules/aws_network"
  env                  = "dev"
  vpc_name             = "vpc-dev"
  ig_name              = "ig-dev"
  subnet_name          = "subnet-dev"
  rt_name              = "rt-dev"
  project              = "EPAM_Final_Project"
  vpc_cidr             = "10.20.0.0/16"
  public_subnet_cidrs  = ["10.20.1.0/24"]
  owner                = "Evgeniy Dmitrenko"
}


