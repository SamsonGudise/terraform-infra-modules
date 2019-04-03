variable region {
	default = "us-east-1"
}
variable subnet_list {
    type = "list"
    default = ["app","private","web","public"]
}
variable availability_zone {
    type = "list"
    default = ["a","b","c"]
}
variable cidr_block {
	default  = "10.10.0.0/16"
}
variable tags {
	type = "map"
	default {
		Name = "ServicesVPC"
		Owner = "SamsonGudise"
		Purpose = "Service"
	}
}
variable peer_vpc_id {
	default = "vpc-xyzabc456789"
}
variable zone_name {
	default = "k8scluster.local"
}