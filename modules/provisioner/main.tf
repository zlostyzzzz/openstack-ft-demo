resource "null_resource" "provision_instance" {
  count = length(var.instance_ips)

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = element(var.instance_ips, count.index)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y docker.io",
      "mkdir -p /tmp/web",
      "bash -c 'cat > /tmp/web/index.html <<EOF\n<html><body><h1>FT using Terraform</h1><p>Hostname: $(hostname)</p><p>IP (internal): $(hostname -I | awk \"{print \\$1}\")</p><p>IP (Public):$(curl ifconfig.me)</p></body></html>\nEOF'",
      "sudo docker run -d --name nginx -p 80:80 -v /tmp/web:/usr/share/nginx/html:ro nginx:alpine"
    ]
  }


}
