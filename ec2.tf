
resource "aws_instance" "ec2-private-1" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  key_name                    = "key1"
 

  network_interface {
    network_interface_id = aws_network_interface.my_network_interface.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
  lifecycle {
    ignore_changes = [
      vpc_security_group_ids,
      root_block_device[0].volume_size,     # or other attributes in root_block_device
      root_block_device[0].delete_on_termination
    ]
  }
  
  tags = {
    Name = "apache-1"
  }
}
resource "aws_instance" "ec2-public-1" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  key_name                    = "key1"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ec2.id]  # Ensure this security group is defined
  subnet_id                   = aws_subnet.public-subnet-1.id

 
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    # Connection information for SSH access
    connection {
      type        = "ssh"
      user        = "ec2-user"  # Change for different AMI types (e.g., ubuntu for Ubuntu instances)
      private_key = file("/home/mai/Downloads/key1.pem") # Path to your SSH private key
      host        = self.public_ip  # Use public IP of the instance
    }
  }
  lifecycle {
    ignore_changes = [
      ami,               # Ignore changes to AMI
      instance_type,     # Ignore changes to instance type
      security_groups,   # Ignore changes to security groups
      subnet_id,         # Ignore changes to subnet
    ]
  }


  tags = {
    Name = "nginx-instance"
  }
}


variable "instance_type" {
  default = "t2.micro"
}
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}



