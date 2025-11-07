variable "project_name" {
  default = "secure-webapp"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "region1" {
  default = "us-east-1"
}

variable "key_name" {
  description = "SSH key name for EC2 access"
  default     = "proj-key"
}
