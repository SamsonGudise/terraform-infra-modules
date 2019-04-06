# Build Custom VPC 

## Create VPC 
Module creates VPC with given CIDR, assign tags and return `vpc_id`
* Inputs:  `CIDR` and `tags`
```
variable tags {
	type = "map"
	default {
		Name = "ServicesVPC"
		Owner = "SamsonGudise"
		Purpose = "Service"
	}
}
```
```
module "create-vpc" {
	cidr_block = "10.10.0.0/16"
	tags = "${var.tags}"
	source  = "create-vpc"
}
```
* Output: `vpc_id`
```
output "vpc_id" {
	value = "vpc-12345abcdef"
}
```

## Create Route Table
Next step create public and private route tables. Also create  Internet Gateway and NAT Gateway(Optional)
* Inputs: `vpc_id` and `tags`
```
module "create-routetable" {
	tags = "${var.tags}"
	vpc_id = "vpc-12345abcdef"
	source = "create-routetable"
}
```

* Output: `route_table_ids (public, private)`
```
output "route_table_ids" {
    value = ["rtb-1234567abcdef","rtb-910112344abcdef"]
}
```
## Create Subnets
Last step create subnets and associate them to route tables based on type (public or private)
* Inputs: `subnet_list`, `availability_zone`, `region`, `vpc_id`, `route_tables` and `tags`.

```
variable region {
	default = "us-west-2pwd
}
variable subnet_list {
    type = "list"
    default = ["name","type","name","type"]
}
variable availability_zone {
    type = "list"
    default = ["a","b","c"]
}

```
* Note: `name`  <- subnet name to subnet and `type` can be `public or private`  case sensitive keywords
```
module "create-subnets" {
	tags = "${var.tags}"
	subnet_list = "${var.subnet_list}"
	availability_zone = "${var.availability_zone}"
	region = "${var.region}"
	vpc_id = "${output of create-vpc module}"
	route_tables = "<${output of create-routetable module}>"
	source = "create-subnet"
}
```
* Output: None