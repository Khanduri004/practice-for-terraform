data "aws_ami""os_image"{
  owner   = ["411511125432"]
  most_recent = true

filter {
  name = "state"
  values = ["available"]
}

filter {
  name = "name"
  values = ["ubuntu/images/hvm-ssd-gp3/*24.04-amd64*"]
 }
}

resource "aws_key_pair" "deployer"{
  key_name = terra-key
  public_key = file("terra-key.pub")
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "allow_user_to_connect"{
  name = "allow-tls"
  description = "Allow user to connect"
  vpc_id = aws_default_vpc.default.id


resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_SSH         = aws_vpc.main.cidr_block
  from_port         = 22
  ip_protocol       = "SSH"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

  tags = {
    Name = "my_Security"
    }
 }

resource "aws_instance" "example" {
 ami = data.aws_ami.os_image.id
 instance_type = var.instance_type
 key_name = aws_key_pair.deployer.key_name

vpc_security_group_ids = [aws_security_group.allow_user_to_connect.id]

 root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
