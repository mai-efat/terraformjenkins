resource "aws_security_group" "ec2" {
  name        = "ec2-security-group"
  description = "Allow traffic to EC2 instances"
  vpc_id      = aws_vpc.terraform-lab-vpc.id 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (consider security settings)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_network_interface" "my_network_interface" {
  subnet_id       = aws_subnet.private-subnet-1.id
  security_groups = [aws_security_group.ec2.id]
  private_ips     = ["10.0.3.10"]

  depends_on = [aws_subnet.private-subnet-1]
}
resource "aws_ebs_volume" "my_ebs_volume" {
  availability_zone = "eu-north-1a"
  size              = 20                # Specify the size in GB
  
 
  tags = {
    Name = "my-ebs-volume"
  }
}

resource "aws_volume_attachment" "my_volume_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.my_ebs_volume.id
  instance_id = aws_instance.ec2-private-1.id
}




