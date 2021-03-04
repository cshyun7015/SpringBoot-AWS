resource "aws_vpc" "VPC" {
  cidr_block  = "9.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "IB07441-VPC-09-SpringBoot-AWS"
  }
}

resource "aws_default_route_table" "DefaultRouteTable" {
  default_route_table_id = aws_vpc.VPC.default_route_table_id

  tags = {
    Name = "IB07441-DefaultRouteTable-SpringBoot-AWS"
  }
}

data "aws_availability_zones" "available" {
}

resource "aws_subnet" "Subnet_Public01" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = "9.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "IB07441-SubnetPublic01-SpringBoot-AWS"
  }
}

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "IB07441-InternetGateway-SpringBoot-AWS"
  }
}

resource "aws_route" "Route_Public" {
  route_table_id = aws_vpc.VPC.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.InternetGateway.id
}

resource "aws_route_table_association" "RouteTableAssociation_SubnetPublic01" {
  subnet_id = aws_subnet.Subnet_Public01.id
  route_table_id = aws_vpc.VPC.main_route_table_id
}

resource "aws_default_network_acl" "DefaultNetworkAcl" {
  default_network_acl_id = aws_vpc.VPC.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "IB07441-DefaultNetworkAcl-SpringBoot-AWS"
  }
}

resource "aws_network_acl" "NetworkAcl_Public" {
  vpc_id = aws_vpc.VPC.id
  subnet_ids = [
    aws_subnet.Subnet_Public01.id
  ]

  tags = {
    Name = "IB07441-NetworkAcl-Public-SpringBoot-AWS"
  }
}

resource "aws_network_acl_rule" "NetworkAclRule_Ingress" {
  network_acl_id = aws_network_acl.NetworkAcl_Public.id
  rule_number = 140
  rule_action = "allow"
  egress = false
  protocol = "-1"
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 65535
}

resource "aws_network_acl_rule" "NetworkAclRule_Egress" {
  network_acl_id = aws_network_acl.NetworkAcl_Public.id
  rule_number = 140
  rule_action = "allow"
  egress = true
  protocol = "-1"
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 65535
}

resource "aws_default_security_group" "DefaultSecurityGroup" {
  vpc_id = aws_vpc.VPC.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "IB07441-DefaultSecurityGroup-SpringBoot-AWS"
  }
}

resource "aws_security_group" "SecurityGroup" {
  name = "IB07441-SecurityGroup-SpringBoot-AWS"
  description = "Security group for IB07441 instance"
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "IB07441-SecurityGroup-SpringBoot-AWS"
  }
}