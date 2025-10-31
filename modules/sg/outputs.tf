output "sg_proxy_id" {
  value = aws_security_group.proxy_sg.id
}

output "sg_backend_id" {
  value = aws_security_group.backend_sg.id
}
