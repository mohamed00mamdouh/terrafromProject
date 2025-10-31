output "proxy_public_ips" {
  value = aws_instance.proxy[*].public_ip
}

output "backend_private_ips" {
  value = aws_instance.backend[*].private_ip
}

output "proxy_instance_ids" {
  value = aws_instance.proxy[*].id
}

output "backend_instance_ids" {
  value = aws_instance.backend[*].id
}
