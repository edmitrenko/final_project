variable "region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "null"
}

variable "env" {
  type        = string
  default     = "null"
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

#################
# Security group
#################
variable "vpc_id" {
  description = "ID of the VPC where to create security group"
# type        = string
  default     = null
}

variable "name" {
  description = "Name of security group "
  type        = string
  default     = null
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {
    ManagedBy   = "terraform"
  }
}

##########
# Ingress
##########
#variable "from_port" {
#  description = "Ingress from_port"
#  type        = number
#  default     = null
#}

#variable "to_port" {
#  description = "Ingress to_port"
#  type        = number
#  default     = null
#}

variable "protocol" {
  description = "Ingress protocol"
  type        = string
  default     = null
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list
  default     = null
}
