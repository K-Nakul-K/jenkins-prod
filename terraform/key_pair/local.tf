locals {
  jenkins_public_key = file("./jenkins-key.pub")
  jenkins_private_key = file("./jenkins-key")
}
