##################################################################
# Base configuration
##################################################################

provider "aws" {
  region                  = "af-south-1"
  shared_credentials_file = "/Users/macielgm/.aws/credentials"
  profile                 = "Africa"
}

##################################################################
# EC2 creation
##################################################################

resource "aws_instance" "EC2_server1" {
  ami           = "ami-0379b9233e97109f7"
  instance_type = "t3.medium"
  vpc_security_group_ids = ["sg-0d77cb874e611015d"]
  subnet_id = "subnet-8926c3e0"
  key_name = "awssupport"
  tags = {
    Name = "LFCE_server1"
    auto-delete = "no"
    auto-stop = "no"
  }

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install gcc telnet nc vim -y
            hostnamectl set-hostname server1.example.local
            echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
            systemctl restart sshd
            echo "172.31.7.191   ipa.example.local" >> /etc/hosts
            EOF
}


resource "aws_instance" "EC2_server2" {
  ami           = "ami-0379b9233e97109f7"
  instance_type = "t3.medium"
  vpc_security_group_ids = ["sg-0d77cb874e611015d"]
  subnet_id = "subnet-8926c3e0"
  key_name = "awssupport"
  tags = {
    Name = "LFCE_server2"
    auto-delete = "no"
    auto-stop = "no"
  }

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install gcc telnet nc vim -y
            hostnamectl set-hostname server2.example.local
            echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
            systemctl restart sshd
            echo "172.31.7.191   ipa.example.local" >> /etc/hosts
            EOF
}
