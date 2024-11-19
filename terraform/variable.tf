variable "region" {
  description = "region where we will be creating Jenkins Master node/server"
  type = string
}

variable "create_key_pair" {
  description = "This variable lets you create key pair which will be used by Jenkins master node."
  default = true
}