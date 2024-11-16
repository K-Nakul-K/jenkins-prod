locals {
  // deafult tags are applied to all the resources TF creates
  default_tags = {
    automation = true
    terraform  = true
    // add more default tags as required
  }
  region = var.region
}