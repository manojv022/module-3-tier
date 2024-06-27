resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block

    tags = {
        Name = var.vpc_name
    } 
}

resource "aws_subnet" "nginx-subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_block[0]
  availability_zone = var.subnet_az[0]
  map_public_ip_on_launch = var.public_ip[0]

  tags = {
    Name = var.subnet_name[0]
  }
}

resource "aws_subnet" "tom-subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_block[1]
  availability_zone = var.subnet_az[1]
  map_public_ip_on_launch = var.public_ip[1]

  tags = {
    Name = var.subnet_name[1]
  }

}

resource "aws_subnet" "db-subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_block[2]
  availability_zone = var.subnet_az[2]
  map_public_ip_on_launch = var.public_ip[1]

  tags = {
    Name = var.subnet_name[2]
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = var.igw_name
    }
  
}

resource "aws_eip" "elasticip" {
 domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elasticip.id
  subnet_id = aws_subnet.nginx-subnet.id
}

resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    
    }

}

resource "aws_route_table_association" "association" {
  subnet_id = aws_subnet.nginx-subnet.id
  route_table_id = aws_route_table.RT1.id
}

resource "aws_route_table" "RT2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private-association-table" {
  subnet_id = aws_subnet.tom-subnet.id
  route_table_id = aws_route_table.RT2.id
}

resource "aws_route_table_association" "private-association-table-2" {
  subnet_id = aws_subnet.db-subnet.id
  route_table_id = aws_route_table.RT2.id
}

resource "aws_security_group" "sg1" {
  name = var.sg_name
  description = "Allow SSH,mysql,tomcat access"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.ports[4]
  ip_protocol = "tcp"
  to_port = var.ports[4]
}

resource "aws_vpc_security_group_ingress_rule" "tomcat" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.ports[3]
  ip_protocol = "tcp"
  to_port = var.ports[3]
}

resource "aws_vpc_security_group_ingress_rule" "nginx" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.ports[2]
  ip_protocol = "tcp"
  to_port = var.ports[2]
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.ports[1]
  ip_protocol = "tcp"
  to_port = var.ports[1]
  
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.ports[0]
  ip_protocol = "-1"
  to_port = var.ports[0]
}
