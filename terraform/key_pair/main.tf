resource "null_resource" "generate_ssh_key" {
  provisioner "local-exec" {
    command = "ssh-keygen -t rsa -b 4096 -f ${path.module}}/jenkins-key -N '' > /dev/null 2>&1"
  }

  triggers = {
    run_once = "true"
  }

  lifecycle {
    prevent_destroy = true
  }
}
