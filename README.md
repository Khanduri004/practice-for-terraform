1. AWS Core Services with Terraform

Goal: Get comfortable with core AWS services, writing Terraform code, and understanding resource dependencies.

Activities:

VPC & Networking

Create a VPC with public and private subnets across 2 AZs.

Set up Internet Gateway, NAT Gateway, and route tables.

Use Terraform data sources to reference AWS default resources (like AMIs or Security Groups).

EC2 & Security

Launch EC2 instances in public and private subnets.

Create Security Groups with least privilege rules.

Use Terraform outputs to get instance public/private IPs.

S3 & IAM

Create an S3 bucket with versioning and server-side encryption.

Attach IAM roles to EC2 instances to access the bucket.

Use Terraform modules for reusable IAM policies.

2. Infrastructure as Code Best Practices

Goal: Apply modularization, workspaces, and Terraform state management.

Activities:

Create reusable modules for:

VPC + Subnets

EC2 instances

RDS instances

Implement Terraform workspaces:

Separate environments (dev, staging, prod)

Use variables and backend configuration per environment

Manage Terraform state with remote backends (S3 + DynamoDB for locking)

3. Databases & Serverless

Goal: Work with AWS managed services and serverless architecture.

Activities:

RDS

Provision an RDS PostgreSQL instance in private subnets.

Enable encryption at rest and automatic backups.

Use Terraform depends_on to handle dependency between VPC, subnets, and RDS.

Lambda & API Gateway

Write a simple Lambda function (Node.js or Python) triggered via API Gateway.

Configure IAM roles, logging (CloudWatch), and environment variables.

DynamoDB

Create a DynamoDB table with TTL and on-demand capacity.

Grant Lambda function permissions to read/write to the table.

4. Advanced Terraform Patterns

Goal: Implement scalable and production-ready Terraform code.

Activities:

Dynamic & For-Each Resources

Launch multiple EC2 instances dynamically using for_each and maps.

Tag all resources dynamically based on environment variables.

Terraform Provisioners & Null Resources

Use provisioners to configure EC2 after deployment (example: install Nginx).

Secrets Management

Use AWS Secrets Manager or SSM Parameter Store and inject secrets into Lambda or EC2.

5. CI/CD Integration

Goal: Practice Terraform automation for real-world deployments.

Activities:

Write a GitHub Actions or GitLab CI pipeline to:

Validate Terraform code (terraform fmt & terraform validate)

Plan and apply Terraform automatically for a dev environment

Promote to staging/production using workspaces

Store Terraform state remotely in S3 with DynamoDB state locking.

6. Observability & Monitoring

Goal: Add monitoring and alerting to your infrastructure.

Activities:

Create CloudWatch metrics and alarms for:

EC2 CPU utilization

RDS free storage

Set up SNS topic for alert notifications

Integrate Lambda function to send custom CloudWatch metrics

Tips for Maximum Learning

Version Control: Use Git for all Terraform code.

Module Registry: Explore Terraform public modules on registry.terraform.io
.

State Management: Practice importing existing AWS resources into Terraform.

Documentation: Document modules with examples of usage and variable descriptions.
