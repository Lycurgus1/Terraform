# This is to launch an EC2 on AWS

# Provider of cloud services
provider "aws" {
  # Define region to create instance in
  region  = var.region
}

# Create an instance
resource "aws_instance" "max_app_terraform" {
  # Defining ami image
  ami           = var.app_ami_id
  # Defining instance type to be created
  instance_type = var.instance_type
  # Deciding on public IP
  associate_public_ip_address = true
  # Naming instance
  tags = {
      Name = "eng67_max_terraform_ec2"
  }
}

# Create a subnet
resource "aws_subnet" "max_terraform_subnet" {
  # Attach this subnet to devsops student vpc
  vpc_id     = "vpc-07e47e9d90d2076da"
  cidr_block = "172.31.178.0/24"

  tags = {
    Name = "maxs_terraform_subnet"
  }
}


# Create a security group

resource "aws_security_group" "max_sg" {
  vpc_id = "vpc-07e47e9d90d2076da"

  # Create ingress block to allow traffic in
  # Allow port 80 and 0.0.0.0/0
  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Create egress block to allow code out
  # All traffic out

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Attach the instance to the SG and Subnet
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.max_sg.id
 network_interface_id = aws_instance.max_app_terraform.primary_network_interface_id
}
