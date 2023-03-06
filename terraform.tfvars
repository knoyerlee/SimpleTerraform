#### VPC Variables ####

vpc_cidr_block = "10.0.0.0/16"
vpc_tag_name   = "Demo VPC"

#### Internet Gateway Variables ####

ig_tag_name = "Demo Internet Gateway"

#### Route Table Variables ####
route_cidr_block_ipv4 = "0.0.0.0/0"
route_cidr_block_ipv6 = "::/0"
route_table_name      = "Demo Route Table"

#### Subnet ####
subnet_cidr_block = "10.0.1.0/24"
subnet_az         = "us-east-1a"
subnet_name       = "Demo Subnet"

#### Security Group ####

sg_name        = "allow-web"
sg_description = "Allow inbound web traffic"
sg_ingress = {
  "ssh" = {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  http = {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  https = {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
