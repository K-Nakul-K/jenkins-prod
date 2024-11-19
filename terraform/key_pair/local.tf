locals {
  jenkins_public_key = file("${path.module}/jenkins-key.pub")
  jenkins_private_key = file("${path.module}/jenkins-key")
}
