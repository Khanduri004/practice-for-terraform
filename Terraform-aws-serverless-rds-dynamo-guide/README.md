Terraform: Databases & Serverless (RDS Postgres, Lambda + API Gateway, DynamoDB)

This document contains a complete, step-by-step Terraform project you can apply locally to provision:

An RDS PostgreSQL instance in private subnets (encrypted at rest, automatic backups)

A DynamoDB table (on-demand billing) with TTL

A Lambda (Python) function that writes to DynamoDB and is exposed via API Gateway (HTTP API)

IAM roles & policies, CloudWatch logging

This is a demo-friendly setup. Review and harden before using in production (state backend, secrets management, subnet sizing, security groups, removal of skip_final_snapshot, etc.).

Prerequisites

AWS account and credentials configured locally (e.g. aws configure or environment variables).

Terraform installed (>= 1.5.0 recommended).

zip available on your machine (for packaging lambda) — the Terraform archive data source will create the zip for us.

Optional: psql client if you plan to connect to Postgres from a bastion host.

___________________________________________________________________________________________________________________________

1. VPC (aws_vpc)

Think of a VPC (Virtual Private Cloud) as your own private neighborhood inside AWS.

It has a big boundary (CIDR block, e.g., 10.0.0.0/16) that defines the full “area” of IP addresses you can use.

Inside this neighborhood, you can create houses (EC2, RDS, Lambda in VPC, etc.).

👉 Analogy: The VPC is the whole gated community.

2. Subnets (aws_subnet)

Inside your neighborhood (VPC), you divide land into smaller plots = subnets.

Public subnet: Has a road connected to the main highway (Internet). Any house (EC2, ALB, etc.) here can get internet access directly.

Private subnet: Only has roads within the neighborhood. No direct highway connection. Houses here can talk to each other, but not directly to the internet (unless you add special exits like NAT Gateway).

👉 Analogy:

Public subnet = houses with a driveway connected to the main city road.

Private subnet = houses inside the community, no direct exit.

3. Internet Gateway (aws_internet_gateway)

This is the main gate of the neighborhood.

Without it, even if you have a road (public subnet), you cannot connect to the city (internet).

You attach it to the VPC, and then say “traffic from public subnet goes through this gate.”

👉 Analogy: The front gate of your community that connects your roads to the main city highway (internet).

4. Route Table (aws_route_table)

A route table is the map of where traffic goes.

Example: “If a car wants to go to 0.0.0.0/0 (the internet), send it to the Internet Gateway.”

Each subnet must be associated with a route table.

👉 Analogy: The GPS map that tells cars in your neighborhood:

“Go left to reach the grocery store.”

“Go out the front gate (internet gateway) to reach the city.”

5. Route Table Association (aws_route_table_association)

This is how you attach a subnet to a specific map (route table).

Without it, the subnet doesn’t know where to send traffic.

👉 Analogy: Assigning a map copy to each smaller area in your neighborhood.

Public subnets use a map with a route to the internet gateway.

Private subnets use a map with only internal roads.

Putting it all together (story 🏡🚗🌐)

You create a VPC = your gated neighborhood.

You divide it into subnets = smaller plots (some public, some private).

You place an Internet Gateway = front gate of the neighborhood.

You create a Route Table = map that says “to reach the internet, exit through the gate.”

You use Route Table Association = give that map to the public subnet.

The private subnet doesn’t get that route — so it has no internet exit.

👉 Result:

EC2 in public subnet: can be accessed from the internet (e.g., web server).

EC2 in private subnet: safe from the internet, but can talk inside the VPC (e.g., RDS database).

_______________________________________________________________________________________________________________________

Question : 
Can you please explain what is the need for versions.tf , i mean why can't we normally write for terafform.tf and then providers.tf . 
And depends_on also . We have to create an RDS instance , so far creation of an instance we do need a vpc id and subnet as we are creating for ec2 then why in this are we using this function cause this is also an instance creation activity . Also please explain iam.tf and apigw.tf . 
I'm a begginer please explain in easiest way possible .

Answer :
1. Why versions.tf?

Terraform is made of many “lego blocks”:

Terraform itself (the tool)

Providers (AWS, Azure, GCP, etc.)

👉 The versions.tf file is like a requirements.txt (Python) or package.json (Node.js).

It locks Terraform version (>= 1.5.0) → so your team all use the same Terraform features.

It locks provider versions (hashicorp/aws ~> 5.30) → so your AWS resources behave the same.

Without this file:

If your friend runs Terraform with AWS provider v4 and you run v5 → resources may behave differently.

By keeping this file, you guarantee consistency across machines and time.

💡 You can put this inside terraform.tf, but people usually keep it separate for clarity.

2. Why depends_on for RDS?

Good catch ✅

Normally Terraform figures out the order itself:

RDS needs a VPC + subnets → Terraform sees those dependencies through references (aws_subnet.private_a.id).

So, in most cases you don’t need depends_on.

👉 Then why use it?

To make the dependency explicit (helpful for beginners to understand order).

Or when Terraform cannot detect dependency automatically (rare).

So in our case:

We used depends_on just to show you that “VPC → Subnets → DB subnet group → RDS” is the order.”

Without it, Terraform would still work, because we’re referencing the subnet group and security group.

💡 Analogy:
Terraform is smart like a chef who sees you need to chop onions before cooking them. depends_on is like shouting:

“HEY CHEF — definitely chop onions first, no matter what!”

3. IAM.tf (IAM Roles & Policies for Lambda)

IAM = Identity and Access Management → who can do what.

For Lambda to run, it needs permissions:

Basic Execution Role → allows Lambda to write logs to CloudWatch.

DynamoDB Permissions → allows Lambda to read/write items in the DynamoDB table.

So in iam.tf we create:

An IAM Role: “costume” that Lambda wears when it runs.

Attach policies: like superpowers we give to the costume.

👉 Analogy:

IAM Role = costume for an actor (Lambda).

Policy = list of powers (can log, can write to DB).

Without the costume → Lambda has no powers.

4. apigw.tf (API Gateway + Lambda integration)

API Gateway = front door for your Lambda.

Without it, Lambda is just a function sitting alone in AWS.

With API Gateway, you get a URL (like https://xyz.execute-api.aws.com/hello) that anyone can call → triggers Lambda.

In apigw.tf:

Create API Gateway (HTTP API type).

Create an integration → tells API Gateway “when someone calls this URL, run this Lambda.”

Create a route → maps a path (like /hello) to the integration.

Create a stage → makes the API public ($default = always deploy latest).

Add lambda_permission → allow API Gateway to invoke the Lambda.

👉 Analogy:

Lambda = a chef in the kitchen.

API Gateway = the waiter who takes customer orders.

Integration = the path from waiter → kitchen.

Route = menu item (e.g., “GET /hello”).

Permission = kitchen pass (so waiter can ask the chef).

5. Quick Recap

versions.tf → locks Terraform + provider versions (like requirements.txt).

depends_on → forces Terraform order (useful but not always needed).

iam.tf → creates IAM role & policies so Lambda can log + access DynamoDB.

apigw.tf → sets up API Gateway as the public URL to call your Lambda.

✅ So, when someone opens your API Gateway URL:

API Gateway (waiter) takes the request.

Passes it to Lambda (chef wearing IAM role costume).

Lambda writes to DynamoDB (thanks to IAM permissions).

Logs the request in CloudWatch (thanks to IAM permissions).

If needed, Lambda could also connect to RDS (if inside VPC).
