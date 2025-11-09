# Secure Web App on AWS — Terraform Project
## Overview

This Terraform project builds a secure web application architecture on AWS with the following components:

- VPC (10.0.0.0/16)
- 2 Public subnets (NGINX reverse-proxy EC2 instances)
- 2 Private subnets (backend EC2 instances running a web app — Flask/Node.js)
- Internet Gateway
- NAT Gateway (for private instances to reach the internet)
- Public Application Load Balancer (ALB) routing traffic to proxy instances
- Internal ALB routing traffic from proxies to backend instances
- Remote state stored in an S3 bucket (with DynamoDB state locking)

## Project structure 
```
├── modules
│   ├── vpc
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── alb
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2
|   |   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── sg
|   |   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── subnets
|   |   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
├── scripts
|   ├── installing_backend.sh
│   └── installing_proxy.sh
├── provider.tf
├── main.tf
├── backend.tf
├──
├── variables.tf
├── outputs.tf
└── README.md
```

Each module must include `main.tf`, `variables.tf`, and `outputs.tf` as required.

## Key technical notes (how this repo satisfies your requirements)

1. **Workspace**: This project uses a dedicated workspace `dev` (you must create it — see Usage).
2. **Remote state**: Example S3 backend + DynamoDB lock is included in `envs/dev/backend.tf`.
3. **Custom modules**: The architecture is implemented via custom modules inside `modules/` — each module contains `main.tf`, `variables.tf`, `outputs.tf` only.
4. **Provisioners**:
   - `remote-exec` or `file` provisioner is used to install/configure Nginx (or Apache) on proxy EC2s.
   - `file` provisioner copies the web app files from your local machine to the private backend EC2 instances.
   - `local-exec` prints/captures IPs and writes them to `all-ips.txt` in the requested format.
5. **AMI lookup**: Use the `aws_ami` data source to fetch the latest image (by owner + name/filters).

... (content truncated for brevity)
