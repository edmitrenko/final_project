provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket where to SAVE Terraform State
    key        = "prod/servers/terraform.tfstate"               // Object name in the bucket to SAVE Terraform State
    region     = "eu-central-1"                                 // Region where bycket created
   }
}
#======================================================================================================================


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "prod/network/terraform.tfstate"                // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}


data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "prod/sg/terraform.tfstate"                     // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}

#======================================================================================================================

module "prod-tomcat1" {
  env                    = "prod"
  name                   = "prod-tomcat1"  
  source                 = "github.com/edmitrenko/terraform_modules/aws_ec2"
  subnet_id              = data.terraform_remote_state.network.outputs.prod_public_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.security_group.outputs.security_group_id_80-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_22-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_all-icmp, data.terraform_remote_state.security_group.outputs.security_group_id_prod-tomcat]
  key_name               = "key-london"
  project                = "EPAM_Final_Project"   
  owner                  = "Evgeniy Dmitrenko"
}

module "prod-tomcat2" {
  env                    = "prod"
  name                   = "prod-tomcat2"  
  source                 = "github.com/edmitrenko/terraform_modules/aws_ec2"
  subnet_id              = data.terraform_remote_state.network.outputs.prod_public_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.security_group.outputs.security_group_id_80-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_22-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_all-icmp, data.terraform_remote_state.security_group.outputs.security_group_id_prod-tomcat]
  key_name               = "key-london"
  project                = "EPAM_Final_Project"   
  owner                  = "Evgeniy Dmitrenko"
}

