resource "aws_vpc" "servicesvpc" {
	cidr_block = "${var.cidr_block}"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags = "${var.tags}"
}

## Create VPC peering to given VPC
module "vpc-peering" {
	cidr_block="${var.cidr_block}"
	peer_vpc_id="${var.peer_vpc_id}"
	local_vpc_id = "${aws_vpc.servicesvpc.id}"
	peer_region="${var.region}"
	source = "vpc-peering"
}

## Create subnets with given list from ${var.subnet_list}
module "create-subnets" {
	tags = "${var.tags}"
	subnet_list = "${var.subnet_list}"
	availability_zone = "${var.availability_zone}"
	region = "${var.region}"
	vpc_id = "${aws_vpc.servicesvpc.id}"
	route_tables = "${module.create-routetable.route_table_ids}"
	source = "subnets"
}

## Create public and private route-tables  
## Create IGW, NAT Gateway and update both public and private route-tables
## Add route to both route-tables to enable routing to peering VPC 
module "create-routetable" {
	tags = "${var.tags}"
	vpc_id = "${aws_vpc.servicesvpc.id}"
	peer_vpc_id = "${var.peer_vpc_id}"
	peer_connection_id = "${module.vpc-peering.peer_id}"
	nat_needed = true
	source = "route-tables"
}
## Create HostedZone
// module "route53" {
// 	vpc_id = "${module.create-vpc.vpc_id}"
// 	zone_name = "${var.zone_name}"
// 	source = "create-hostedzone"
// }

output "vpc_id" {
	value = "${aws_vpc.servicesvpc.id}"
}
