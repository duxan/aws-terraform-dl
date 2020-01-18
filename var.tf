variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "ami_name" {
  default = "Deep Learning *"
}

variable "instance_type" {
  default = "p2.xlarge"
}

variable "ebs_volume_size" {
  type        = string
  default     = "50"
  description = "The Amazon EBS volume size (1 GB - 16 TB)."
}
