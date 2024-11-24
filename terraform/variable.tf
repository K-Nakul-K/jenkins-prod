variable "region" {
  description = "region where we will be creating Jenkins Master node/server"
  type = string
}

variable "create_key_pair" {
  description = "This variable lets you create key pair which will be used by Jenkins master node."
  default = true
}

variable "create_vpc" {
  description = "change this value to false if VPC ID is user provided"
  type = bool
  default = true
}

variable "vpc_id" {
  description = "Provide VPC ID if its already created, else use create_vpc use as true"
  type = string
  default = "user_provided_vpc_id"
}

variable "public_subnets" {
  description = "Provide list of public subnets if its already created, else use create_vpc use as true"
  type = list()
  default = []
}

variable "private_subnets" {
  description = "Provide list of private subnets if its already created, else use create_vpc use as true"
  type = list()
  default = []
}

variable "vpc_cidr" {
  description = "Provide VPC cidr if its already created, else use create_vpc use as true"
  type = string
  default = ""
}