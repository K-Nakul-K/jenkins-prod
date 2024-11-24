data "aws_availability_zones" "available" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp3",
    ]
  }
}

data "template_file" "jenkins_user_data" {
  template = file("${path.module}/jenkins_install.tpl")
}