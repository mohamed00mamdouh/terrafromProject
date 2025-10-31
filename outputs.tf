output "vpc_id" {
  value = module.vpc.vpc_id
}

output "proxy_public_ips" {
  value = module.ec2.proxy_public_ips
}

output "backend_private_ips" {
  value = module.ec2.backend_private_ips
}

output "public_alb_dns" {
  value = module.alb.public_alb_dns
}

output "internal_alb_dns" {
  value = module.alb.internal_alb_dns
}
