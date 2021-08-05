resource "aws_vpc" "ELK-vpc" {
    cidr_block = "10.0.0.0/16" # 254 IP addresses in this subnet
    
    tags = {
        Name="ELK-vpc"
    }
}

resource "aws_subnet" "ELK-subnet-public" {
    vpc_id = "${aws_vpc.ELK-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" # it makes this a public subnet
    availability_zone = "eu-west-2a"
    tags = {
        Name = "ELK-subnet-public"
    }
}
