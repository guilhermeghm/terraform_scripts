##################################################################
# Base configuration
##################################################################

provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "/Users/macielgm/.aws/credentials"
  profile                 = "default"
}


##################################################################
# Cluster creation.
##################################################################

resource "aws_elasticache_replication_group" "ec-cluster-off" {
  replication_group_id          = "ec-cluster-off"
  replication_group_description = "Cluster Mode disabled"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 2
  port                          = 6379
  parameter_group_name          = "default.redis5.0"
  automatic_failover_enabled    = true
  engine_version                = "5.0.4"
  subnet_group_name             = "eu-west-1"
  engine                        = "redis"
}


resource "aws_elasticache_replication_group" "ec-cluster-auth" {
  replication_group_id          = "ec-cluster-auth"
  replication_group_description = "Cluster Mode disabled Auth"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 2
  port                          = 6379
  parameter_group_name          = "default.redis5.0"
  automatic_failover_enabled    = true
  engine_version                = "5.0.4"
  subnet_group_name             = "eu-west-1"
  engine                        = "redis"
  transit_encryption_enabled    = true
  auth_token                    = "Elast1c3che#Auth5322"
}

resource "aws_elasticache_replication_group" "ec-cluster-on" {
  replication_group_id          = "ec-cluster-on"
  replication_group_description = "Cluster Mode enabled"
  node_type                     = "cache.t2.micro"
  port                          = 6379
  parameter_group_name          = "default.redis5.0.cluster.on"
  automatic_failover_enabled    = true
  engine_version                = "5.0.4"
  subnet_group_name             = "eu-west-1"
  engine                        = "redis"

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 2
  }
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "memcached"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.5"
  subnet_group_name    = "eu-west-1"
  port                 = 11211
}

##################################################################
# EC2 creation
##################################################################

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.EC2client.id}"
  allocation_id = "eipalloc-0363463ab8366517f"
}

resource "aws_instance" "EC2client" {
  ami           = "ami-0bbc25e23a7640b9b"
  instance_type = "m5.large"
  vpc_security_group_ids = ["sg-8fe0b5f7"]
  subnet_id = "subnet-697cda32"
  key_name = "awssupport"
  tags = {
    Name = "EC Training"
    auto-delete = "no"
    auto-stop = "no"
  }

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install gcc telnet nc -y
            cd /opt
            wget http://download.redis.io/redis-stable.tar.gz
            tar xvzf redis-stable.tar.gz
            cd redis-stable
            make
            echo "PATH=$PATH:$HOME/bin:$HOME/opt/redis-stable/src" >> /home/ec2-user/.bash_profile
            echo "export PATH"
            echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
            systemctl restart sshd
            EOF
}
