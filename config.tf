# AWS configuration should be set in your configuration file at
# ~/.aws/config

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# Push tfstate from s3
#terraform {
#  backend "s3" {
#    bucket = "demo-terraform-state"
#    key    = "demo/laks/autoscaling.tfstate"
#    region = "ap-southeast-1" #hardcoded on purpose
#  }
#}
