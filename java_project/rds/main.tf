provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  name           = "mysql"
  instance_class = "db.t3.micro"
  }

################################################################################
# RDS Module
################################################################################
terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket where to SAVE Terraform State
    key        = "rds/terraform.tfstate"                        // Object name in the bucket to SAVE Terraform State
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

# Generate Password
resource "random_string" "rds_password" {
  length           = 12
  special          = false
# override_special = "!#$&"

  keepers = {
    kepeer1 = var.name
   }
}

# Store Password in SSM Parameter Store
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master Password for RDS MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

# Get Password from SSM Parameter Store
data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

module "db" {
  source               = "github.com/edmitrenko/terraform_modules/aws_rds"

  identifier           = local.name

  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = local.instance_class

  allocated_storage    = 10
  
  db_name              = "UserDB"
  username             = "admin"
  password             = data.aws_ssm_parameter.my_rds_password.value
  port                 = 3306
  
  vpc_security_group_ids = [data.terraform_remote_state.security_group.outputs.security_group_id_3306-tcp]

  skip_final_snapshot     = true 
  owner                   = "Evgeniy Dmitrenko"
  project                 = "final_project"
  env                     = "prod"  
}

resource "null_resource" "db_setup" {
  triggers = {
    file = filesha1("initial.sql")
  }
  
  provisioner "local-exec" {
      command = "mysql --host=${module.db.db_instance_address} --port=${module.db.db_instance_port} --user=${module.db.db_instance_username} --password=${module.db.db_instance_password} --database=${module.db.db_instance_name} < initial.sql"
    }
}  