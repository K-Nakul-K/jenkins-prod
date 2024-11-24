locals {
  // deafult tags are applied to all the resources TF creates
  default_tags = {
    automation = true
    terraform  = true
    // add more default tags as required
  }
  region = var.region
  name   = "jenkins-prod"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}