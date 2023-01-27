output "instace_1_ip_address" {
  value       = aws_instance.instance_1.public_ip
  description = "EC2 instace_1 ip address"
}
