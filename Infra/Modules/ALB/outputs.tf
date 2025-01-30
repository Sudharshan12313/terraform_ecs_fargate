output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "sg_id" {
  description = "List of security group IDs for ALB"
  value       = [aws_security_group.app_alb_sg.id]  # Ensure it's a list
}