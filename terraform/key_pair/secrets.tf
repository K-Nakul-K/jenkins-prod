data "local_file" "public_key_content" {
  filename = local.jenkins_public_key
  depends_on = [null_resource.generate_ssh_key]
}

resource "aws_secretsmanager_secret" "jenkins_public_key" {
  name        = "jenkins_public_key"
  description = "Public Key to be stored on EC2"
}

resource "aws_secretsmanager_secret_version" "jenkins_public_key_version" {
  secret_id     = aws_secretsmanager_secret.jenkins_public_key.id
  secret_string = data.local_file.public_key_content.content
  depends_on = [null_resource.generate_ssh_key]
}

data "local_file" "private_key_content" {
  filename = local.jenkins_private_key
  depends_on = [null_resource.generate_ssh_key]
}

resource "aws_secretsmanager_secret" "jenkins_private_key" {
  name        = "jenkins_private_key"
  description = "Private key to connect EC2 via SSH"
}

resource "aws_secretsmanager_secret_version" "jenkins_private_key_version" {
  secret_id     = aws_secretsmanager_secret.jenkins_private_key.id
  secret_string = data.local_file.private_key_content.content
  depends_on = [null_resource.generate_ssh_key]
}