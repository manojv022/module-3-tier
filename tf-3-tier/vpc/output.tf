output "vpc_id" {
    value = aws_vpc.vpc.id
  
}

output "sg_id" {
    value = aws_security_group.sg1.id
  
}

output "public_subnet_id" {
    value = aws_subnet.nginx-subnet.id
  
}

output "pri1_subnet_id" {
    value = aws_subnet.tom-subnet.id
  
}

output "pri2_subnet_id" {
    value = aws_subnet.db-subnet.id
  
}
