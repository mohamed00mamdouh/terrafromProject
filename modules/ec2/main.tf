resource "aws_instance" "proxy" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = element(var.public_subnet_ids, count.index)
  key_name      = var.key_name
  vpc_security_group_ids = [var.sg_proxy_id]

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  tags = { Name = "proxy-${count.index}" }
}

resource "aws_instance" "backend" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = element(var.private_subnet_ids, count.index)
  key_name      = var.key_name
  vpc_security_group_ids = [var.sg_backend_id]

  provisioner "file" {
    source      = "scripts/install_backend.sh"
    destination = "/tmp/install_backend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_backend.sh",
      "sudo /tmp/install_backend.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.private_ip
  }

  tags = { Name = "backend-${count.index}" }
}
