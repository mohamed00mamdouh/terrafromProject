# Secure Web App with Public Proxy + Private Backend on AWS using Terraform

## 📘 Project Overview
This Terraform project provisions a **secure and scalable web application** architecture on **AWS**.  
The setup includes a **public Nginx reverse proxy layer** and **private backend web servers**, all managed via modular Terraform configuration.

---

## 🏗️ Infrastructure Architecture

The setup includes:

- **VPC (10.0.0.0/16)**
- **2 Public Subnets** → Contain EC2 instances acting as Nginx reverse proxies.
- **2 Private Subnets** → Contain EC2 instances hosting backend web applications (Flask/Node.js).
- **Internet Gateway (IGW)** → Provides internet access for public subnets.
- **NAT Gateway** → Allows private instances to access the internet securely.
- **2 Load Balancers:**
  - **Public ALB** → Routes internet traffic to proxy instances.
  - **Internal ALB** → Routes proxy traffic to backend servers.

---

## ⚙️ Technical Implementation

### 1. Workspace Management
- Do **not** use the default workspace.
- Create a new workspace:
  ```bash
  terraform workspace new dev
  ```

### 2. Remote State Management
- The Terraform state is stored remotely using an **S3 bucket** for better collaboration and versioning.

### 3. Terraform Modules
Each component of the infrastructure is implemented as a **custom Terraform module** (not from the public registry).
Each module contains:
```
main.tf
variables.tf
outputs.tf
```

Modules:
- `vpc` → Creates VPC, subnets, route tables, gateways.
- `ec2` → Launches EC2 instances (proxies and backends).
- `alb` → Configures load balancers.
- `sg` → Sets up security groups.

---

### 4. Provisioners

#### a. Remote-exec
Used to install required software (e.g., Apache, Nginx) on EC2 instances after deployment:
```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt update -y",
    "sudo apt install nginx -y"
  ]
}
```

#### b. Local-exec
After provisioning, it writes all instance IPs to a local file named **all-ips.txt**:
```
public-ip1 1.1.1.1
public-ip2 2.2.2.2
```
Example:
```hcl
provisioner "local-exec" {
  command = "echo 'public-ip1 ${aws_instance.proxy[0].public_ip}' >> all-ips.txt"
}
```

#### c. File Provisioner
Copies application files from your local machine to private EC2 instances:
```hcl
provisioner "file" {
  source      = "./app/"
  destination = "/home/ubuntu/app/"
}
```

---

### 5. Data Sources
Used to dynamically fetch the latest AMI ID for EC2 instances:
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
```

---

## 🧱 Project Structure

```
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── alb/
│   ├── sg/
│
└── app/
    └── backend_files/
```

---

## 🚀 Deployment Steps

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Select/Create Workspace**
   ```bash
   terraform workspace new dev
   ```

3. **Validate Configuration**
   ```bash
   terraform validate
   ```

4. **Plan Deployment**
   ```bash
   terraform plan
   ```

5. **Apply Changes**
   ```bash
   terraform apply -auto-approve
   ```

6. **Output IPs**
   Check the `all-ips.txt` file for generated IP addresses.

---

## 🧩 Outputs
- Public Proxy IPs
- Backend Private IPs
- Load Balancer DNS names

---

## 🔒 Security Notes
- Only ALBs and proxy instances are publicly accessible.
- Backend instances reside in private subnets.
- Security groups are configured for minimal exposure and least privilege.

---

## 🧑‍💻 Author
**Mohamed Mamdouh**  
Terraform | AWS | DevOps Engineer

---
