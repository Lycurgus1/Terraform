# This is to launch an EC2 on AWS

# Provider of cloud services
provider "aws" {
  # Define region to create instance in
  region  = var.region
}

# Create a VPC
resource "aws_vpc" "max_terraform_vpc" {
  cidr_block = "122.28.0.0/16"
  tags = {
    Name = "max_terraform_vpc"
  }
}

# Create a subnet
resource "aws_subnet" "max_terraform_subnet_public" {
  # Attach this subnet to devsops student vpc
  vpc_id                  = aws_vpc.max_terraform_vpc.id
  cidr_block              = "122.28.1.0/24"
  # This makes the subnet public
  map_public_ip_on_launch = "true"
  tags = {
    Name = "max_terraform_subnet"
  }
}

# Create a internet gateway
resource "aws_internet_gateway" "max_terraform_igw" {
  vpc_id = aws_vpc.max_terraform_vpc.id

  tags = {
    Name = "max_terraform_igw"
  }
}


# Create a route table
resource "aws_route_table" "max_terraform_routetable" {
  # Attach this to devsops student vpc
  vpc_id     = aws_vpc.max_terraform_vpc.id
  # Assign the internet gateway to this route table
  route {
      cidr_block = "0.0.0.0/0"      
      gateway_id = aws_internet_gateway.max_terraform_igw.id
  }
    
  tags = {
      Name = "max_terraform_routetable"
  } 
}


# Associating the subnet and route table
resource "aws_route_table_association" "max_subnet_assoiciation"{
    subnet_id = aws_subnet.max_terraform_subnet_public.id
    route_table_id = aws_route_table.max_terraform_routetable.id
}

# Create a NACL
resource "aws_network_acl" "max_terraform_nacl" {
  vpc_id = aws_vpc.max_terraform_vpc.id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.max_terraform_vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "max_terraform_nacl"
  }

}


# Create a security group
resource "aws_security_group" "max_sg" {
  vpc_id = aws_vpc.max_terraform_vpc.id

  # Create ingress block to allow traffic in
  # Allow port 80 and 0.0.0.0/0
  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allowing SSH from my IP
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["91.110.41.40/32"]
    }

  # Create egress block to allow code out
  # All traffic out

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "max_terraform_sg"
  }

}

# Create an instance
resource "aws_instance" "max_app_terraform" {
  # Defining ami image
  ami           = var.app_ami_id

  # Defining instance type to be created
  instance_type = var.instance_type

  # Deciding on public IP
  associate_public_ip_address = true

  # VPC
  subnet_id = aws_subnet.max_terraform_subnet_public.id 
   
  # Security Group
  vpc_security_group_ids = ["${aws_security_group.max_sg.id}"]
   
  # the Public SSH key
  key_name = "DevOpsStudents"    

  # Naming instance
  tags = {
      Name = "eng67_max_terraform_ec2"
  }
}

# Auto statring app
provisioner "file" {
        source = "nginx.sh"
        destination = "/tmp/nginx.sh"
    }
    provisioner "remote-exec" {
        inline = [
             "chmod +x /tmp/nginx.sh",
             "sudo /tmp/nginx.sh"
        ]
    }

}
