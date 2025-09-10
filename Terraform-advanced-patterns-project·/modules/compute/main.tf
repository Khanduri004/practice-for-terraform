# upload public key as an AWS key pair
resource "aws_key_pair" "deployer" {
key_name = "tf-demo-key-${replace(substr(md5(var.public_key_path),0,8), "\"", "") }"
public_key = file(var.public_key_path)
}


# Create instances using for_each on the provided map
resource "aws_instance" "web" {
for_each = var.instances
ami = var.ami_id
instance_type = each.value.instance_type
subnet_id = var.subnet_id
vpc_security_group_ids = [var.security_group_id]
key_name = aws_key_pair.deployer.key_name
iam_instance_profile = var.instance_profile


associate_public_ip_address = true


tags = merge(var.tags, { Name = each.value.name, TerraformKey = each.key })
}


# A null_resource provisioner that runs after an instance is created. Use for_each so we
# have one provisioner resource per instance. It depends on the instance and the key pair.
resource "null_resource" "provision" {
for_each = aws_instance.web


# triggers cause the null_resource to re-run if the instance changes
triggers = {
instance_id = each.value.id
ami = each.value.ami
}


provisioner "remote-exec" {
connection {
type = "ssh"
host = each.value.public_ip
user = "ec2-user" # Amazon Linux 2 user
private_key = file(var.private_key_path)
timeout = "2m"
}


inline = [
# install utilities
"sudo yum update -y",
"sudo yum install -y nginx unzip",


# install AWS CLI v2 (works on Amazon Linux 2)
"curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o awscliv2.zip || true",
"unzip -o awscliv2.zip || true",
"sudo ./aws/install || true",


# fetch the secret from Secrets Manager and write a small HTML page
"SECRET=$(aws secretsmanager get-secret-value --secret-id ${var.secret_arn} --region ${var.aws_region} --query SecretString --output text) || true",
"echo \"<html><body><h1>Demo Nginx</h1><p>Secret: $SECRET</p></body></html>\" | sudo tee /usr/share/nginx/html/secret.html",


# start nginx
"sudo systemctl enable --now nginx"
]
}


# make sure this runs only after the instance is ready
depends_on = [aws_instance.web, aws_key_pair.deployer]
}


output "instance_public_ips" {
value = { for k, i in aws_instance.web : k => i.public_ip }
}
