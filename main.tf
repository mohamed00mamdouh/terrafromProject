data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}


module "subnets" {
  source           = "./modules/subnets"
  vpc_id           = module.vpc.vpc_id
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
}


module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}


module "ec2" {
  source           = "./modules/ec2"
  ami_id           = data.aws_ami.amazon_linux.id
  key_name         = var.key_name
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  sg_proxy_id      = module.sg.sg_proxy_id
  sg_backend_id    = module.sg.sg_backend_id
}


module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.subnets.public_subnet_ids
  private_subnets    = module.subnets.private_subnet_ids
  proxy_target_ids   = module.ec2.proxy_instance_ids
  backend_target_ids = module.ec2.backend_instance_ids
}


resource "null_resource" "write_ips" {
  provisioner "local-exec" {
    command = <<EOT
echo public-ip1 ${module.ec2.proxy_public_ips[0]} > all-ips.txt
echo public-ip2 ${module.ec2.proxy_public_ips[1]} >> all-ips.txt
EOT
  }
}
