##################################################################
# Base configuration
##################################################################

provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "/Users/macielgm/.aws/credentials"
  profile                 = "default"
}

##################################################################
# EC2 creation
##################################################################

resource "aws_instance" "EC2_server1" {
  ami           = "ami-0a3c2e3ecfcddf2d1"
  instance_type = "t3.medium"
  vpc_security_group_ids = ["sg-7552d20f"]
  subnet_id = "subnet-d8148ebf"
  key_name = "awssupport"
  tags = {
    Name = "LFCS_server1"
    auto-delete = "no"
    auto-stop = "no"
  }

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install gcc telnet nc vim -y
            hostnamectl set-hostname server1.mydomain.local
            echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
            systemctl restart sshd
            EOF
}


resource "aws_instance" "EC2_server2" {
  ami           = "ami-0a3c2e3ecfcddf2d1"
  instance_type = "t3.medium"
  vpc_security_group_ids = ["sg-7552d20f"]
  subnet_id = "subnet-d8148ebf"
  key_name = "awssupport"
  tags = {
    Name = "LFCS_server2"
    auto-delete = "no"
    auto-stop = "no"
  }

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install gcc telnet nc vim -y
            hostnamectl set-hostname server2.mydomain.local
            echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
            systemctl restart sshd
            EOF
}
