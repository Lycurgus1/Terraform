# Creating reusable variables to use in main.tf

variable "app_ami_id" {
    type = string
    default = "ami-0ae4f9fefc0735a61"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "region" {
    type = string
    default = "eu-west-1"
}
