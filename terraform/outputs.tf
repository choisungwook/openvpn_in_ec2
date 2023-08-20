output "openvpn_public_ip" {
  description = "openvpn가 설치된 ec2 instance public ip"
  value       = aws_instance.openvpn.public_ip
}

output "nginx_private_ip" {
  description = "nginx가 설치된 ec2 instance private ip"
  value       = aws_instance.nginx.private_ip
}
