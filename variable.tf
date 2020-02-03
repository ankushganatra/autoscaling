################################################################################
# VPC
################################################################################
variable "region" {
  default = "ap-southeast-1"
}

variable "common_tags" {
  description = "A common tags which should be utilised by all resources."
  type        = map(string)

  default = {
    Owner       = "DevOps"
    Project     = "Demo"
    Provisioner = "Terraform"
  }
}

variable "vpc_azs" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "vpc_cidr" {
  type  = string
  default = "192.0.0.0/16"
}

variable "private_subnets" {
  type  = list(string)
  default = ["192.0.1.0/24", "192.0.2.0/24", "192.0.3.0/24"]
}

variable "public_subnets" {
  type  = list(string)
  default = ["192.0.101.0/24", "192.0.102.0/24", "192.0.103.0/24"]
}


variable "access_key" {
  type = string
  default = "" 
}
variable "secret_key" {
  type = string
  default = "" 
}

variable azs_name {
  type = list(string)
  default = [ "ap-southeast-1a","ap-southeast-1b","ap-southeast-1c" ]
}

variable "public_key" {
 description = "Public key string" 
 default = ""
}
variable "key_name" {
 description = "Key name for SSHing into EC2"
 default = "custom_ssh_key"
}

