# Setting aws region for required providers
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "instance_1" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "dev-server"
  }

  key_name               = aws_key_pair.marcelo-ssh-key.id
  vpc_security_group_ids = [aws_security_group.lab1-security-group.id]
  subnet_id              = aws_subnet.lab1-public-subnet.id

  root_block_device {
    volume_size = 10
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = var.ansible_user
      private_key = file("~/.ssh/id_rsa")
      host        = aws_instance.instance_1.public_ip
    }
  }
  provisioner "local-exec" {
    working_dir = "./ansible/"
    command = "ansible-playbook  -i ${aws_instance.instance_1.public_ip}, --extra-vars='ansible_user=${var.ansible_user}' -u ${var.ansible_user} docker-engine.yaml"
  }
}

resource "local_file" "inventory" {
  filename = "${path.module}/ansible/hosts"
  content  = <<EOF
[ec2_instances:vars]
ansible_connection=ssh
ansible_user=${var.ansible_user}
[ec2_instances]
${aws_instance.instance_1.public_ip}
EOF
}