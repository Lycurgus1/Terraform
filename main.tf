# This is to launch an EC2 on AWS

# Provider of cloud services
provider "aws" {
  # Define region to create instance in
  region  = "eu-west-1"
}

# Create an instance
resource "aws_instance" "max_app_terraform" {
  # Defining ami image
  ami           = "ami-0ae4f9fefc0735a61"
  # Defining instance type to be created
  instance_type = "t2.micro"
  # Deciding on public IP
  associate_public_ip_address = true
  # Naming instance
  tags = {
      Name = "eng67_max_terraform_ec2"
  }
}
