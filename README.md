# Terraform

## Installing Terraform

### These instructions apply for Windows systems

### 1. Download 32-bit Windows for Terraform

```https://www.terraform.io/downloads.html```

### 2. Copy it into a program folder

A. Go to programs x 86
B. Create a folder named terraform
C. Unzip the Terraform file into this folder

### 3. Navigate to system settings 

A. Go to Control panel

B. System

C. Advanced system settings

D. Click on Environemental variables

### 4. Add the path environmental variable

A. Scroll down the Enviromental variables (system variables) to find path

B. In path variable click edit

C. Click new within the path variable

D. Copy the file path from the terraform folder within program files 86 here

### 5. Shut down and restart your console to run terraform

A. Run the below command to test terraform is working

```terraform -help```

B. You should get the below result if succesful

installation_succesful.PNG

## What is terraform

**Two sides of IAC**

- Configuration management (Ansible)
- Orchestration (Terraform, Kubernetes)
	- If used in containerisation docker used
	- Crio, rocket are also used

## Terraform commands

- terraform init
- terraform plan
	- checks steps in code and lists successes/errors
- terraform apply
	- implements code
