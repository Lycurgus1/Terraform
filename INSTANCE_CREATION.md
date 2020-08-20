# How to create an instance with Terraform

## Dependencies

- Install Terraform per main readme
- Git Bash is needed for the linux environmnet

```https://git-scm.com/downloads```

## Steps

### 1. Create main.tf and variables.tf

```
nano main.tf
nano variables.tf
```

### 2. Write main.tf per example

- curly brackets define code

```
# This is to launch an EC2 on AWS

# Provider of cloud services
provider "aws" {
  # Define region to create instance in
  region  = "eu-west-1"
}
```

### 3. Intialise Terraform

```terraform init``` 

- should say terraform has been intialised

### 4. Enable EC2 creation

- Insert the below to main.tf

```
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
```

- This will likely generate an error as you have not added access keys yet

### 5. Add access and secret key to the environmental variables

- Advanced system settings
	- Per keys given to us

### 6. Create the instance

- Test your file for errors

```terraform plan```

- Once there are no errors run the file

```terraform apply```

- You should see an instance created

### 7. Creating subnets and security groups

- Insert this into your main.tf file

```
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
```

### 9. Attaching the Instance to the security group

- Insert this into your main.tf file

```
# Attach the instance to the SG and Subnet
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.max_sg.id
 network_interface_id = aws_instance.max_app_terraform.primary_network_interface_id
```

