resource "aws_secretsmanager_secret" "jenkins_public_key" {
  name        = "jenkins_public_key"
  description = "Public Key to be stored on EC2"
}

resource "aws_secretsmanager_secret_version" "jenkins_public_key_version" {
  secret_id     = aws_secretsmanager_secret.jenkins_public_key.id
  secret_string = local.jenkins_public_key
}

resource "aws_secretsmanager_secret" "jenkins_private_key" {
  name        = "jenkins_private_key"
  description = "Private key to connect EC2 via SSH"
}

resource "aws_secretsmanager_secret_version" "jenkins_private_key_version" {
  secret_id     = aws_secretsmanager_secret.jenkins_private_key.id
  secret_string = local.jenkins_private_key
}