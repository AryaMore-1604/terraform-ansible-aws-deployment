terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "ap-south-1"
}

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "terraform-ansible-app-sg"
  description = "Allow SSH and Node.js application traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node.js Application"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ansible-app-sg"
  }
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = "ami-06e8305d564d9bec7"
  instance_type          = "t2.micro"
  key_name               = "devops-key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "terraform-ansible-node-app"
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for EC2 SSH to become available..."

      until ssh -o StrictHostKeyChecking=no \
                -o ConnectTimeout=5 \
                -i ~/.ssh/devops-key.pem \
                ubuntu@${self.public_ip} "echo SSH_READY" 2>/dev/null
      do
        echo "SSH not ready yet. Waiting 10 seconds..."
        sleep 10
      done

      echo "SSH is ready!"

      echo "Generating inventory.ini..."
      cat > inventory.ini <<EOF
[webservers]
${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/devops-key.pem
EOF

      echo "Running Ansible playbook..."
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml
    EOT
  }
}

# Outputs
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "application_url" {
  description = "Node.js application URL"
  value       = "http://${aws_instance.app_server.public_ip}:3000"
}
