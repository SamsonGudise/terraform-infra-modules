resource "aws_elasticache_replication_group" "RedisReplica" {
  automatic_failover_enabled    = true
  availability_zones            = ["ap-south-1a", "ap-south-1b"]
  replication_group_id          = "model-cache-4"
  replication_group_description = "test description"
  node_type                     = var.node_type
  number_cache_clusters         = 2
  port                          = 6379

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}

resource "aws_elasticache_cluster" "replica" {
  count = 3

  cluster_id           = "model-cache-4-${count.index}"
  replication_group_id = aws_elasticache_replication_group.RedisReplica.id
}

resource "aws_elasticache_cluster" "RedisReplica" {
  cluster_id           = "model-cache-4"
  engine               = "Clusted Redis1"
  parameter_group_name =  "default.redis5.0.cluster.on"//var. parameter_group_name
  node_type            = var.node_type
  num_cache_nodes      = 1
  engine_version       = var.engine_version
  port                 = 6379
}