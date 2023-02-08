provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket where to SAVE Terraform State
    key        = "dev/servers/terraform.tfstate"                // Object name in the bucket to SAVE Terraform State
    region     = "eu-central-1"                                 // Region where bycket created
   }
}
#======================================================================================================================


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket from where to GET Terraform State
    key        = "dev/network/terraform.tfstate"                // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                 // Region where bycket created
    }
}


data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "dev/sg/terraform.tfstate"                      // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}

#======================================================================================================================
module "dev-tomcat" {
  env                    = "dev"
  name                   = "dev-tomcat"  
  source                 = "github.com/edmitrenko/final_project/modules/aws_ec2" 
  subnet_id              = data.terraform_remote_state.network.outputs.dev_public_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.security_group.outputs.security_group_id_8080-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_22-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_all-icmp]
  key_name               = "key-london"
  project                = "EPAM_Final_Project"   
  owner                  = "Evgeniy Dmitrenko"
}

module "dev-ansible" {
  env                    = "dev"
  name                   = "dev-ansible"  
  source                 = "github.com/edmitrenko/final_project/modules/aws_ec2"
  subnet_id              = data.terraform_remote_state.network.outputs.dev_public_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.security_group.outputs.security_group_id_22-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_all-icmp]
  project                = "EPAM_Final_Project" 
  key_name               = "key-london"
  user_data              = local.user_data_ubuntu  
  owner                  = "Evgeniy Dmitrenko"
}

module "dev-jenkins" {
  env                    = "dev"
  name                   = "dev-jenkins"  
  source                 = "github.com/edmitrenko/final_project/modules/aws_ec2"
  subnet_id              = data.terraform_remote_state.network.outputs.dev_public_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.security_group.outputs.security_group_id_8080-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_22-tcp, data.terraform_remote_state.security_group.outputs.security_group_id_all-icmp]
  key_name               = "key-london"
  project                 = "EPAM_Final_Project"
  owner                   = "Evgeniy Dmitrenko"   
}