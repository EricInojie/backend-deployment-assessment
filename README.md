 MuchToDo Backend Deployment Assessment



Project Overview



This project demonstrates the deployment of the MuchToDo Go backend application using Docker, Docker Compose, Terraform and Amazon Web Services (AWS).



The infrastructure is provisioned in the AWS Stockholm region (`eu-north-1`).



Technologies Used



\- AWS EC2

\- AWS VPC

\- AWS Application Load Balancer (ALB)

\- AWS Security Groups

\- Terraform

\- Docker

\- Docker Compose

\- Go 1.25.1

\- MongoDB 8.0

\- Amazon Linux 2



\ Infrastructure Architecture



The Terraform configuration provisions:



\- One VPC (`10.0.0.0/16`).

\- Two public subnets across two Availability Zones.

\- Two private subnets across two Availability Zones.

\- One Internet Gateway.

\- One NAT Gateway.

\- One Bastion EC2 instance.

\- One private Backend EC2 instance.

\- One private MongoDB EC2 instance.

\- Four security groups.

\- One internet-facing Application Load Balancer.

\- One target group with an HTTP health check.



 Network and Security Design



| Component | Access |

|---|---|

| Application Load Balancer | Public HTTP traffic on port 80 |

| Bastion | SSH port 22 from the configured administrator IP |

| Backend EC2 | Port 8080 from the ALB; SSH from Bastion |

| MongoDB EC2 | Port 27017 from the Backend security group only |



The Backend EC2 instance is not directly exposed to the public internet.



Application Deployment



The MuchToDo backend and MongoDB were deployed as Docker Compose services on the private Backend EC2 instance.



A separate MongoDB EC2 instance was also provisioned by Terraform as part of the infrastructure assessment. The running Compose application currently uses its own MongoDB container rather than that separate instance.



 Project Structure



```text

backend-deployment-assessment/

│

├── cmd/

├── docs/

├── internal/

├── evidence/

│

├── terraform/

│   ├── main.tf

│   ├── variables.tf

│   ├── outputs.tf

│   ├── network.tf

│   ├── security\_groups.tf

│   ├── compute.tf

│   ├── load\_balancer.tf

│   ├── terraform.tfvars.example

│   └── user\_data/

│       ├── backend\_setup.sh

│       └── mongodb\_setup.sh

│

├── Dockerfile

├── docker-compose.yml

├── .dockerignore

├── .env.example

├── .gitignore

├── go.mod

├── go.sum

├── Makefile

└── README.md

```



\## Prerequisites



Install the following tools:



\- Terraform

\- AWS CLI

\- Docker Desktop

\- Git

\- An AWS account with permissions to create the required infrastructure.

\- An existing EC2 key pair.



Configure AWS CLI credentials and confirm that the correct AWS identity is active before deployment.



 Terraform Deployment



 1. Configure variables



Navigate to the Terraform directory:



```bash

cd terraform

```



Copy the example variables file:



```bash

copy terraform.tfvars.example terraform.tfvars

```



On Windows Command Prompt, the command above creates the actual variables file.



Edit `terraform.tfvars` and provide:



\- AWS region.

\- Project name.

\- EC2 instance type.

\- Existing EC2 key pair name.

\- Administrator public IP address in CIDR notation (`/32`).



Never commit the actual `terraform.tfvars` file.



 2. Initialize Terraform



```bash

terraform init

```



\### 3. Review the execution plan



```bash

terraform plan -out=tfplan

```



 4. Provision infrastructure



```bash

terraform apply tfplan

```



 5. View infrastructure outputs



```bash

terraform output

```



The outputs include the ALB DNS name, Bastion public IP, Backend private IP, MongoDB private IP and VPC ID.



 Docker Deployment



 1. Build the application image



From the project root:



```bash

docker build -t muchtodo-backend:local .

```



 2. Configure environment variables



Create a local `.env` file from `.env.example` and supply appropriate development credentials and secrets.



Do not commit `.env`.



 3. Start the local application



```bash

docker compose up -d --build

```



 4. Check container status



```bash

docker compose ps

```



 5. Test the health endpoint



```bash

curl -i http://localhost:8080/health

```



The expected response is HTTP 200.



 AWS EC2 Deployment



The backend instance is located in a private subnet and is accessed through the Bastion host.



The deployment process involved:



1\. Connecting to the Bastion using the EC2 key pair.

2\. Connecting to the private Backend EC2 through SSH ProxyCommand.

3\. Installing Docker and Docker Compose.

4\. Transferring the application files and Docker image.

5\. Loading the Docker image into the remote Docker engine.

6\. Starting the application using Docker Compose.

7\. Confirming both containers were healthy.



The backend was deployed using:



```bash

sudo docker compose up -d --no-build

```



Check the deployment:



```bash

sudo docker compose ps

```



Inspect application logs:



```bash

sudo docker compose logs --tail=60 backend

```



 Application Health Verification



The application health endpoint is:



```text

/health

```



The deployed application returned:



```text

HTTP/1.1 200 OK

{"cache":"disabled","database":"ok"}

```



The AWS Application Load Balancer target group also reported one healthy target and zero unhealthy targets.



\## Security Considerations



\- Backend EC2 is deployed in a private subnet.

\- SSH access to the Bastion is restricted to the administrator IP.

\- Backend access is restricted to the ALB and Bastion security groups.

\- MongoDB access is restricted to the Backend security group.

\- Environment variables and application secrets must not be committed.

\- Private SSH keys must not be uploaded to GitHub.

\- Terraform state files must be stored securely.



 Evidence



The `evidence/` directory contains screenshots documenting the assessment, including:



1\. Terraform initialization.

2\. Terraform execution plan.

3\. Terraform apply.

4\. VPC creation.

5\. Subnet configuration.

6\. Security group rules.

7\. EC2 instances.

8\. ALB target health.

9\. Docker image build.

10\. Local Docker Compose deployment.

11\. Local backend health check.

12\. SSH connection through Bastion.

13\. EC2 Docker Compose deployment.

14\. Public ALB health check.



\## Infrastructure Teardown



To avoid unnecessary AWS charges after completing the assessment, destroy the Terraform-managed infrastructure:



```bash

terraform -chdir=terraform destroy

```



Review the destruction plan and type `yes` when prompted.



\*\*Important:\*\* Save all required evidence and securely preserve the Terraform state before destroying the infrastructure. AWS charges incurred before teardown, and any resources not managed by Terraform, may still incur costs.



&#x20;Author



Eric Inojie



Junior DevOps engineer



MuchToDo Backend Deployment Assessment



Technologies: AWS | Terraform | Docker | Docker Compose | Go | MongoDB



