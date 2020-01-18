# GPU-accelerated EC2 with Jupyter -  AWS automation with Terraform

## What this Terraform script does  
1. Creates a key-pair and puts it in your working directory.
1. Creates an AWS Security Group that is pre-configured for Jupyter Notebooks.
1. Creates an AWS EC2 Instance using the Deep learning AMI.
1. Attaches the EBS root volume to the instance.
1. Configures the Jupyter Notebook config file for use with AWS.

## Steps:
1. Install Terraform
2. Edit `var.tf` to be sure you chose AMI, ec2 instance type and other according to your need
3. Run `terraform init`
4. Run `terraform plan --out tfplan` 
5. Run `terraform apply tfplan`
6. DON'T forget to   
    a. take volume snapshot  
    b. stop the instance or  
    c. destroy everything when you don't use it: `terraform destroy`
7. DON'T checkout tfstate files and/or credentials to public repoes 

## File Structure
```
.
├── main.tf
├── output.tf
├── script.sh
└── var.tf
```

### main.tf
This is the *main* Terraform file. It includes all the resources created in AWS.

### output.tf
This is where you can have Terraform output certain attributes after it has completed running.

### script.sh
This is a bash shell script that executes when the EC2 instance is created. Creates and configures the Jupyter Notebook config file to make Jupyter Notebook AWS friendly.

### var.tf
This is where Terraform stores variables used in `main.tf`. Edit this file if you need different resources or setup (different AMI, instance type, etc.)

## Connect to the instance OR just open Jupyter Notebook
1. OPTIONAL: Connect to your instance by running the following command: `ssh -i <keyname>.pem ubuntu@<public-dns>`. The connection string is outputted by Terraform. You will be prompted *Are you sure you want to connect?* So, type `yes` and press enter/return.
1. OPTIONAL: You'll see that you've entered your EC2 instance.
1. OPTIONAL: Start up the Jupyter Notebook server by running the command `jupyter notebook`.
1. You'll see a URL as terraform output. Copy and paste that link in your browser. Jupyter Notebook will load.
1. Happy coding!
1. When you're done, run the command `terraform destroy` and it will destroy all the resources created by Terraform.

## Credits
Based on this repo: https://github.com/wblakecannon/terraform-jupyter
