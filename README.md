# GPU-accelerated EC2 with Jupyter -  AWS automation with Terraform

## What this Terraform script does  
1. Creates a key-pair and puts it in your working directory.
1. Creates an AWS Security Group that is pre-configured for Jupyter Notebooks.
1. Creates an AWS EC2 Instance using the Deep learning AMI.
1. Creates an EBS volume for [Anaconda](https://www.anaconda.com) Python distribution.
1. Attaches the EBS volume to the instance.
1. Mounts the EBS instance as /anaconda3
1. Downloads [Anaconda](https://www.anaconda.com)
1. Installs [Anaconda](https://www.anaconda.com)
1. Sets the environment variable for [Anaconda](https://www.anaconda.com), python, jupyter, etc
1. Configures the Jupyter Notebook config file for use with AWS.

## Steps:
1. Install Terraform
2. Edit `var.tf` to be sure you chose AMI, ec2 instance type and other according to your need
3. Run `terraform init`
4. Run `terraform plan --out tfplan` 
5. Run `terraform apply tfplan`
6. DON'T forget to stop the instance or destroy everything when you don't use it: `terraform destroy`
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
This is a bash shell script that executes when the EC2 instance is created. It does some lower level Linux stuff and takes care of:

1. Creating a log file for debugging.
1. Updates Amazon Linux 2 packages.
1. Mounts the EBS volume as `/anaconda3`.
1. Edits the `fstab` file inside Amazon Linux 2 to ensure the volume is mounted after a reboot.
1. Downloads and installs Anaconda.
1. Creates and configures the Jupyter Notebook config file to make Jupyter Notebook AWS friendly.

### var.tf
This is where Terraform stores variables used in `main.tf`. Edit this file if you need different resources or setup (different AMI, instance type, etc.)

## Connect to Your Instance and Run Jupyter Notebook
1. Connect to your instance by running the following command: `ssh -i "<keyname>.pem" ec2-user@<public-dns>`. The connection string is outputted by Terraform. You will be prompted *Are you sure you want to connect?* So, type `yes` and press enter/return.
1. You'll see that you've entered your EC2 instance.
1. Start up the Jupyter Notebook server by running the command `jupyter notebook`.
1. You'll see a URL. Copy and paste that link in your browser. Jupyter Notebook will load.
1. Happy coding!
1. When you're done, run the command `terraform destroy` and it will destroy all the resources created by Terraform.

## Credits
Based on this repo: https://github.com/wblakecannon/terraform-jupyter
