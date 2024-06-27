
resource "aws_network_interface" "network1" {
  subnet_id = var.subnet_1
  private_ip = var.private_ip[0]
}

resource "aws_instance" "nginx" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
   network_interface {
    network_interface_id = aws_network_interface.network1.id
    device_index = 0
  }
   tags = {
    Name = var.instance_name[0]
  }
}

resource "aws_network_interface_sg_attachment" "sg2" {
  security_group_id = var.sg_id
  network_interface_id = aws_instance.nginx.primary_network_interface_id
}

resource "aws_network_interface" "private-network1" {
  subnet_id = var.subnet_2
  private_ip = var.private_ip[1]
}

resource "aws_instance" "tomcat" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  network_interface {
    network_interface_id = aws_network_interface.private-network1.id
    device_index = 0
}
  tags = {
    Name = var.instance_name[1]
  }
}
 
resource "aws_network_interface_sg_attachment""sg-private"{
  security_group_id = var.sg_id
  network_interface_id = aws_instance.tomcat.primary_network_interface_id
}

resource "aws_network_interface" "private-network2" {
  subnet_id = var.subnet_3
  private_ip = var.private_ip[2]
}

resource "aws_instance" "database" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  network_interface {
    network_interface_id = aws_network_interface.private-network2.id
    device_index = 0
  }
  tags = {
    Name = var.instance_name[2]
  }
  }

resource "aws_network_interface_sg_attachment" "sg-private-2" {
  security_group_id = var.sg_id
  network_interface_id = aws_instance.database.primary_network_interface_id
}
