resource "aws_elasticache_replication_group" "example" {
  automatic_failover_enabled    = true
  availability_zones            = ["ap-south-1a", "ap-south-1b"]
  replication_group_id          = "model-cache-1"
  replication_group_description = "test description"
  node_type                     = "cache.r5.large"
  number_cache_clusters         = 2
  port                          = 6379

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}

resource "aws_elasticache_cluster" "replica" {
  count = 1

  cluster_id           = "model-cache-1-${count.index}"
  replication_group_id = aws_elasticache_replication_group.example.id
}
