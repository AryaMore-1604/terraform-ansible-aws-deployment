# Terraform + Ansible Automated AWS Deployment

## 📌 Project Overview

This project demonstrates an automated deployment workflow using **Terraform and Ansible** on AWS.

Terraform is used to provision the AWS infrastructure, including an EC2 instance and security group. After the EC2 instance is created, Terraform's `local-exec` provisioner automatically waits for SSH connectivity, generates the Ansible inventory, and executes the Ansible playbook.

Ansible then configures the Ubuntu EC2 instance, installs Node.js and Git, clones a Node.js application, installs its dependencies, and starts the application.

## 🏗️ Architecture

```text
Developer
    |
    | terraform apply
    v
Terraform
    |
    +----------------------+
    |                      |
    v                      v
AWS Security Group      AWS EC2
SSH :22                 Ubuntu
App :3000               t2.micro
                            |
                            | SSH
                            v
                     Ansible Playbook
                            |
              +-------------+-------------+
              |             |             |
              v             v             v
             Git          Node.js      npm install
              |
              v
        Node.js Application
              |
              v
          Port 3000
```

## 🚀 Technologies Used

* AWS EC2
* Terraform
* Ansible
* Ubuntu
* Node.js
* Git
* SSH
* WSL / Linux

## 📁 Project Structure

```text
terraform-ansible-deployment/
│
├── main.tf
├── playbook.yml
├── inventory.ini
├── README.md
└── .gitignore
```

## ⚙️ Terraform Configuration

Terraform provisions:

* Ubuntu EC2 instance
* `t2.micro` instance type
* AWS security group
* SSH access on port `22`
* Node.js application access on port `3000`
* `devops-key` EC2 key pair
* Public IP output
* Application URL output

## 🤖 Ansible Configuration

The Ansible playbook performs the following tasks:

1. Updates the Ubuntu package cache.
2. Installs Git and curl.
3. Configures the NodeSource repository.
4. Installs Node.js 20.
5. Creates the application directory.
6. Clones the Node.js application repository.
7. Installs npm dependencies.
8. Checks whether the application is already running.
9. Starts the application if it is not already running.

## 🔄 Automated Deployment Flow

Running:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

automatically performs the following:

```text
Terraform creates EC2
        ↓
Terraform waits for SSH
        ↓
Terraform generates inventory.ini
        ↓
Terraform executes Ansible
        ↓
Ansible configures EC2
        ↓
Node.js application is deployed
        ↓
Application runs on port 3000
```

## 🧪 Verification

After deployment, Terraform provides the EC2 public IP and application URL:

```text
instance_public_ip = <EC2_PUBLIC_IP>
application_url    = http://<EC2_PUBLIC_IP>:3000
```

The application can also be tested from the terminal:

```bash
curl http://<EC2_PUBLIC_IP>:3000
```

## 🔐 Security Notes

Sensitive files and Terraform state are excluded from Git using `.gitignore`.

The following files should never be committed:

```text
*.pem
terraform.tfstate
terraform.tfstate.*
```

For production environments, SSH access should also be restricted to trusted IP addresses instead of allowing `0.0.0.0/0`.

## 🎯 Learning Outcomes

Through this project, I practiced:

* AWS EC2 provisioning with Terraform
* Terraform resource configuration
* AWS security group configuration
* Terraform outputs
* Terraform `local-exec` provisioners
* Automated Ansible execution
* Dynamic Ansible inventory generation
* Node.js deployment on Ubuntu
* SSH-based configuration management
* Infrastructure as Code
* Configuration Management
* End-to-end deployment automation

## 👨‍💻 Author

**Arya More**

BSc Computer Science | DevOps & Cloud Enthusiast

GitHub: AryaMore-1604
