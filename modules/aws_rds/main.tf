data "aws_partition" "current" {}

resource "random_id" "snapshot_identifier" {
  
  keepers = {
    id = var.identifier
  }

  byte_length = 4
}

data "aws_availability_zones" "available" {
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "prod/network/terraform.tfstate"                // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}

resource "aws_db_subnet_group" "this" {
  name                    = var.project
  subnet_ids              = "${data.terraform_remote_state.network.outputs.prod_public_subnet_ids}" 
  tags                    = {
   Name                  = "DB subnet group"
 }
}

resource "aws_db_instance" "this" {
  identifier             = var.identifier
  
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  port                   = var.port
 
  db_subnet_group_name   = aws_db_subnet_group.this.name
  multi_az               = false
  publicly_accessible    = true
  vpc_security_group_ids = var.vpc_security_group_ids
  
  skip_final_snapshot    = var.skip_final_snapshot
  
  tags                   = var.tags
}