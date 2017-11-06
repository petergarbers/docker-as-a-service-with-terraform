variable "appname" {
  default = "docker-as-a-service"
}

variable "prefix" {}
variable "profile" {}

variable "region" {
  default = "us-west-2"
}

provider "aws" {
  profile    = "${var.profile}"
  region     = "${var.region}"
}

terraform {
  backend "s3" {
  }
}

# ec2
variable "ec2_ami_id" {}
variable "ec2_instance_size" {}

# keypair
variable "runit_executeable" {}
variable "identity_location" {}
variable "public_key" {}

# EXISTING RESOURCES
variable "subnet_id" {}

variable "vpc_id" {} # Default vpc that is used for everything, should probably change