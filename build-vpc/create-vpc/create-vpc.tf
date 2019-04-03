variable cidr_block {}
variable tags {
	type = "map"
}
resource "aws_vpc" "servicesvpc" {
	cidr_block = "${var.cidr_block}"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags = "${var.tags}"
}
output "vpc_id" {
	value = "${aws_vpc.servicesvpc.id}"
}