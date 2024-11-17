resource "null_resource" "generate_ssh_key" {
  provisioner "local-exec" {
    command = "ssh-keygen -t rsa -b 2048 -f jenkins-key -N '' > /dev/null 2>&1"
  }

  triggers = {
    # Use a timestamp or a custom value, but once created it won't trigger again
    run_once = "true"
  }

  lifecycle {
    prevent_destroy = true  # Prevent this resource from being destroyed
  }
}
