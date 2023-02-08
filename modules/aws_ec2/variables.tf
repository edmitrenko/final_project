variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = "null"
}

variable "env" {
  default = "null"
}

variable "project" {
  description = "Please Enter Project name"
  type        = string
  default     = "null"
}

variable "owner" {
  description = "Please Enter owner of Project"
  type        = string
  default     = "null"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {
    ManagedBy   = "terraform"
  }
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "key_name" {
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources"
  type        = string
  default     = null
}


