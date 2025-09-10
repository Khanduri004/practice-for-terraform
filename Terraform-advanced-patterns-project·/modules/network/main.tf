
resource "aws_vpc" "this" {
cidr_block = var.cidr_block
tags = merge(var.tags, { Name = var.name })
}


resource "aws_subnet" "public" {
vpc_id = aws_vpc.this.id
cidr_block = var.public_subnet_cidr
map_public_ip_on_launch = true
tags = merge(var.tags, { Name = "${var.name}-public-subnet" })
}

resource "aws_vpc" "this" {
gateway_id = aws_internet_gateway.igw.id
}
tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}


resource "aws_route_table_association" "public" {
subnet_id = aws_subnet.public.id
route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "web_sg" {
name = "${var.name}-web-sg"
vpc_id = aws_vpc.this.id


ingress {
description = "SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = [var.allowed_cidr]
}


ingress {
description = "HTTP"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}


tags = merge(var.tags, { Name = "${var.name}-web-sg" })
