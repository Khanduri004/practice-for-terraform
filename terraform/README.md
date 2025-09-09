VPC & Networking Create a VPC with public and private subnets across 2 AZs. 
Set up Internet Gateway, NAT Gateway, and route tables. Use Terraform data sources to reference AWS default resources (like AMIs or Security Groups). 
EC2 & Security Launch EC2 instances in public and private subnets. Create Security Groups with least privilege rules. 
Use Terraform outputs to get instance public/private IPs. S3 & IAM Create an S3 bucket with versioning and server-side encryption. 
Attach IAM roles to EC2 instances to access the bucket. Use Terraform modules for reusable IAM policies.
