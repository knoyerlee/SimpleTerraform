#### VPC ####
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_tag_name
  }
}

#### Internet Gateway ####
resource "aws_internet_gateway" "demo-igateway" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = var.ig_tag_name
  }
}

#### Route Table ####
resource "aws_route_table" "demo-route-table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = var.route_cidr_block_ipv4 # Default route send everything to internet gateway.
    gateway_id = aws_internet_gateway.demo-igateway.id
  }

  route {
    ipv6_cidr_block = var.route_cidr_block_ipv6 # Default route send everything to internet gateway.
    gateway_id      = aws_internet_gateway.demo-igateway.id
  }

  tags = {
    Name = var.route_table_name
  }
}

#### Subnet ####
resource "aws_subnet" "demo-subnet" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.subnet_az

  tags = {
    Name = var.subnet_name
  }
}

#### Associate Route Table with Subnet ####
resource "aws_route_table_association" "association-a" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-route-table.id
}

#### Create a Security Group ####
resource "aws_security_group" "allow-web-traffic" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.demo-vpc.id

  dynamic "ingress" {
    for_each = var.sg_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }


  egress {
    # Allow everything out.
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow Web"
  }
}

#### Network Interface ####
resource "aws_network_interface" "demo-network-interface" {
  subnet_id       = aws_subnet.demo-subnet.id
  private_ips     = ["10.0.1.13"] # Creates private ip w/n subnet.
  security_groups = [aws_security_group.allow-web-traffic.id]
}

#### Create Elastic IP ####
resource "aws_eip" "demo-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.demo-network-interface.id
  associate_with_private_ip = "10.0.1.13"
  depends_on = [
    aws_internet_gateway.demo-igateway
  ]
}

#### EC2 Instance ####
resource "aws_instance" "demo-ec2" {
  ami               = "ami-0557a15b87f6559cf"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "main-ssh-key"
  network_interface {
    network_interface_id = aws_network_interface.demo-network-interface.id
    device_index         = 0
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              EOF
  depends_on = [
    aws_internet_gateway.demo-igateway
  ]

  tags = {
    Name = "Demo Instance"
  }
}


