# Outputs
output "bastion_host_ip" {
  description = "Bastion host public IP address"
  value = aws_instance.bastion-host.public_ip
}
output "load_balancer_domain_name" {
  description = "Application Load Balancer domain name"
  value = aws_alb.alb.dns_name
}
