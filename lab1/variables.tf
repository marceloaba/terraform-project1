variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "ami" {
  type        = string
  default     = "ami-0574da719dca65348"
  description = "AWS machine image ID to use for EC2 instances (Ubuntu Server 22.04 LTS us-east-1 AMD64)"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "ansible_user" {
  type        = string
  default     = "ubuntu"
  description = "Ansible EC2 instance username"
}
