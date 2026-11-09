
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Name prefix for assessment resources"
  type        = string
  default     = "muchtodo-assessment"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name in the selected region"
  type        = string
}

variable "user_ip" {
  description = "Your public IP address with /32 for restricted SSH access"
  type        = string
}
