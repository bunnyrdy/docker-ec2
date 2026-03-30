resource "aws_instance" "docker" {
  ami                    = data.aws_ami.joindevops.id  # This is our devops-practice AMI ID
  vpc_security_group_ids = [aws_security_group.allow_all_docker.id]
  instance_type          = "t3.micro"

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = file("docker.sh")
  



   
# user_data = <<EOF
# #!/bin/bash
# sudo dnf -y install dnf-plugins-core
# sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
# sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# sudo systemctl start docker
# sudo systemctl enable docker
# sudo usermod -aG docker ec2-user
# newgrp docker
# EOF 

  tags = {
    Name = "docker-instance"
  }
  
}



resource "aws_security_group" "allow_all_docker" {
  name        = "allow_all_docker"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


output "docker_ip" {
  value       = aws_instance.docker.public_ip
}