# Terraform Cloud Infrastructure Project

## Overview
This Terraform project sets up a cloud infrastructure that includes:
- **VPC** for networking
- **ECS (Fargate)** for containerized applications
- **RDS** for database storage
- **Redis** for caching
- **Security Groups** for access control
- **CloudWatch** for monitoring
- **CI/CD** via GitHub Actions for automated deployments

The setup is scalable, automated, and optimized for high availability.

---

## Project Structure
```
.github/workflows/
  ├── ci-cd-frontend.yml
  ├── ci-cd-rds.yml
  ├── ci-cd-redis.yml

dev-tf-project/
  ├── backend_rds/
  │   ├── settings.py
  │   ├── urls.py
  │   ├── wsgi.py
  │   ├── core/
  │   ├── Dockerfile
  │   ├── manage.py
  │   ├── requirements.txt
  ├── backend_redis/
  │   ├── settings.py
  │   ├── urls.py
  │   ├── wsgi.py
  │   ├── core/
  │   ├── Dockerfile
  │   ├── manage.py
  │   ├── requirements.txt
  ├── frontend/
  │   ├── settings.py
  │   ├── urls.py
  │   ├── wsgi.py
  │   ├── core/
  │   ├── templates/
  │   ├── index.html
  │   ├── Dockerfile
  │   ├── manage.py
  │   ├── requirements.txt

terraform/
  ├── alb.tf
  ├── cloudwatch_logs.tf
  ├── discovery.tf
  ├── ecs.tf
  ├── frontend-task-definition.json
  ├── iam.tf
  ├── outputs.tf
  ├── rds.tf
  ├── redis.tf
  ├── route_tables.tf
  ├── security_groups.tf
  ├── terraform.tfstate.*.backup
  ├── vpc.tf

.env
.gitignore
docker-compose.yml
README.md
```

---

## Prerequisites
Ensure you have the following installed before proceeding:
- Terraform
- AWS CLI
- Docker & Docker Compose
- GitHub Actions (for CI/CD pipelines)

---

## Installation
1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <project-folder>
   ```
2. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```
3. Create and apply the infrastructure:
   ```bash
   terraform apply
   ```

---

## Deployment
1. Build and push Docker images:
   ```bash
   docker-compose build
   docker-compose push
   ```
2. Deploy ECS services:
   ```bash
   terraform apply -auto-approve
   ```
3. Check logs and monitor services using AWS CloudWatch.

---

## Architecture
- **VPC & Networking**: The project uses a custom VPC with public and private subnets.
- **ECS (Fargate)**: The frontend, backend (RDS), and backend (Redis) run on Fargate with service discovery.
- **RDS**: A PostgreSQL database with security groups restricting access.
- **Redis**: Managed Redis for caching and performance optimization.
- **IAM Roles**: Defined IAM roles for ECS tasks and execution.
- **Security Groups**: Rules for securing network access.

---

## CI/CD Pipeline
- **GitHub Actions** workflows:
  - `ci-cd-frontend.yml`: Builds and deploys frontend container.
  - `ci-cd-rds.yml`: Builds and deploys RDS backend.
  - `ci-cd-redis.yml`: Builds and deploys Redis backend.
- Automatically triggers builds and deploys on each push.

---

## Monitoring & Logging
- **AWS CloudWatch**: Logs for ECS tasks and application monitoring.
- **Terraform Outputs**: Displays key resources such as Load Balancer URL and database endpoints.

---

## Contributors
- Vitaliy Prymak

---

