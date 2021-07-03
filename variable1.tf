variable "engine" {
default ="Clustered Redis"
}

 variable "node_type" {
default = "cache.r5.large"
}

  variable "parameter_group_name" {
default = "default.redis5.0.cluster.on"
}
   variable "engine_version" {
default = "5.0.4"
}