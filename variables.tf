#### VPC Variables ####

variable "vpc_cidr_block" {
  description = "The CIDR block used for our VPC we will create"
  type        = string
}

variable "vpc_tag_name" {
  description = "Name tag for the VPC"
  type        = string
}

#### Internet Gateway ####

variable "ig_tag_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

#### Route Table ####

variable "route_cidr_block_ipv4" {
  description = "Value of the ipv4 cidr block for the route table"
  type        = string
}

variable "route_cidr_block_ipv6" {
  description = "Value of the ipv6 cidr block for the route table"
  type        = string
}

variable "route_table_name" {
  description = "Name tag for the route table"
  type        = string
}

#### Subnet ####

variable "subnet_cidr_block" {
  description = "Value of the subnet block"
  type        = string
}

variable "subnet_az" {
  description = "AZ zone for subnet"
  type        = string
}

variable "subnet_name" {
  description = "Name Tag for Subnet"
  type        = string
}

#### Security Group ####

variable "sg_name" {
  description = "Name of the SG"
  type        = string
}

variable "sg_description" {
  description = "Description for SG"
  type        = string
}

variable "sg_ingress" {
  description = "Map of Ingress Values for SG"
  type = map(object({
    description = string,
    from_port   = number,
    to_port     = number,
    protocol    = string,
    cidr_blocks = list(string),
  }))
}


