## Create Virtual Private Cloud (VPC)
module "create-vpc" {
	cidr_block = "${var.cidr_block}"
	tags = "${var.tags}"
	source  = "create-vpc"
}

## Create VPC peering to given VPC
module "vpc-peering" {
	cidr_block="${var.cidr_block}"
	peer_vpc_id="${var.peer_vpc_id}"
	local_vpc_id = "${module.create-vpc.vpc_id}"
	peer_region="${var.region}"
	source = "vpc-peering"
}

## Create subnets with given list from ${var.subnet_list}
module "create-subnets" {
	tags = "${var.tags}"
	subnet_list = "${var.subnet_list}"
	availability_zone = "${var.availability_zone}"
	region = "${var.region}"
	vpc_id = "${module.create-vpc.vpc_id}"
	route_tables = "${module.create-routetable.route_table_ids}"
	source = "create-subnet"
}

## Create public and private route-tables  
## Create IGW, NAT Gateway and update both public and private route-tables
## Add route to both route-tables to enable routing to peering VPC 
module "create-routetable" {
	tags = "${var.tags}"
	vpc_id = "${module.create-vpc.vpc_id}"
	peer_vpc_id = "${var.peer_vpc_id}"
	peer_connection_id = "${module.vpc-peering.peer_id}"
	nat_needed = true
	source = "create-routetable"
}
## Create HostedZone
module "route53" {
	vpc_id = "${module.create-vpc.vpc_id}"
	zone_name = "${var.zone_name}"
	source = "create-hostedzone"
}