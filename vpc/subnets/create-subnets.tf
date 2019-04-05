variable vpc_id {}
variable region {}
variable route_tables {
    type = "list"
}
variable subnet_list {
    type = "list"
}
variable availability_zone {
    type = "list"
}
variable tags {
  type = "map"
}

## Query VPC to Create Subnets - Yes, we can pass this as variable, instead of query this value. 
## But why pass 2 parameters if you can query :-)  
data "aws_vpc" "selected" {
    id = "${var.vpc_id}"
}
resource "aws_subnet" "services-subnets" {
    count = "${(length(var.subnet_list)/2)*(length(var.availability_zone))}"
    vpc_id = "${var.vpc_id}"
    availability_zone = "${var.region}${var.availability_zone[count.index%3]}"
    cidr_block = "${cidrsubnet(data.aws_vpc.selected.cidr_block, 4, count.index)}"
    map_public_ip_on_launch = "${var.subnet_list[1+(2*(count.index/(length(var.availability_zone))))] == "public" ? true : false }"

    tags {
        Name = "${lookup(var.tags, "Purpose")}-${var.subnet_list[2*(count.index/(length(var.availability_zone)))]}-${var.availability_zone[count.index%3]}"
        type = "${var.subnet_list[1+(2*(count.index/(length(var.availability_zone))))]}"
        Owner = "${lookup(var.tags, "Owner")}"
        Purpose = "${lookup(var.tags, "Purpose")}"
    }
}

resource "aws_route_table_association" "assign" {
    count = "${(length(var.subnet_list)/2)*(length(var.availability_zone))}"
    subnet_id      = "${element(aws_subnet.services-subnets.*.id,count.index)}"
    route_table_id = "${var.subnet_list[1+(2*(count.index/(length(var.availability_zone))))] == "public" ? 
    var.route_tables[0] : var.route_tables[1]}"
}