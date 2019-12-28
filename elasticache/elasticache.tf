provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "/Users/macielgm/.aws/credentials"
  profile                 = "default"
}


resource "aws_elasticache_replication_group" "ec-single" {
  replication_group_id          = "ec-single"
  replication_group_description = "Cluster single node"
  node_type                     = "cache.t3.micro"
  number_cache_clusters         = 1
  port                          = 6379
  parameter_group_name          = "default.redis5.0"
  engine_version                = "5.0.5"
  subnet_group_name             = "eu-west-1"
  engine                        = "redis"
  snapshot_window               = "01:00-02:00"
}

resource "aws_elasticache_replication_group" "ec-cluster-off" {
  replication_group_id          = "ec-cluster-off"
  replication_group_description = "Cluster Mode disabled"
  node_type                     = "cache.t3.micro"
  number_cache_clusters         = 2
  port                          = 6379
  parameter_group_name          = "default.redis5.0"
  automatic_failover_enabled    = true
  engine_version                = "5.0.5"
  subnet_group_name             = "eu-west-1"
  engine                        = "redis"
  snapshot_window               = "01:00-02:00"
}


resource "aws_elasticache_replication_group" "ec-cluster-on" {
  replication_group_id          = "ec-cluster-on"
  replication_group_description = "Cluster Mode enabled"
  node_type                     = "cache.t3.micro"
  port                          = 6379
  parameter_group_name          = "default.redis5.0.cluster.on"
  automatic_failover_enabled    = true
  engine_version                = "5.0.5"
  subnet_group_name             = "eu-west-1"
  engine                        = "redis"
  snapshot_window               = "01:00-02:00"

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 2
  }
}

resource "aws_elasticache_replication_group" "ec-cluster-auth" {
  replication_group_id          = "ec-cluster-auth"
  replication_group_description = "Cluster Mode disabled Auth"
  node_type                     = "cache.t3.micro"
  number_cache_clusters         = 2
  port                          = 6379
  parameter_group_name          = "default.redis5.0"
  automatic_failover_enabled    = true
  engine_version                = "5.0.5"
  subnet_group_name             = "eu-west-1"
  engine                        = "redis"
  transit_encryption_enabled    = true
  auth_token                    = "Elast1c3che#Auth5322"
  snapshot_window               = "01:00-02:00"
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "memcached"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.5"
  subnet_group_name    = "eu-west-1"
  port                 = 11211
}
