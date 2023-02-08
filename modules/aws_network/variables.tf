variable "vpc_cidr" {
  default = "10.0.0.0/16"
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

variable "vpc_name" {
  type        = string
  default     = null
}

variable "ig_name" {
  type        = string
  default     = null
}

variable "subnet_name" {
  type        = string
  default     = null
}

variable "rt_name" {
  type        = string
  default     = null
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {
    ManagedBy   = "terraform"
  }
}