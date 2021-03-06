resource "aws_internet_gateway" "ELK-igw" {
    vpc_id = "${aws_vpc.ELK-vpc.id}"
    tags = {
        Name = "ELK-igw"
    }
}

resource "aws_route_table" "ELK-public-rt" {
    vpc_id = "${aws_vpc.ELK-vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.ELK-igw.id}" 
    }
    
    tags = {
        Name = "ELK-public-rt"
    }
}

resource "aws_route_table_association" "ELK-rta-public-subnet"{
    subnet_id = "${aws_subnet.ELK-subnet-public.id}"
    route_table_id = "${aws_route_table.ELK-public-rt.id}"
}


resource "aws_security_group" "ELK-sg" {
  vpc_id = "${aws_vpc.ELK-vpc.id}"
  description				= "Allow SSH, HTTP, HTTPS and ELK ports"
  ingress {
    from_port   		= 22
    to_port     		= 22
    protocol    		= "tcp"
    cidr_blocks 		= ["0.0.0.0/0"]
    description			= "SSH"
  }
  ingress {
    from_port   		= 80
    to_port     		= 80
    protocol    		= "tcp"
    cidr_blocks 		= ["0.0.0.0/0"]
    description			= "HTTP"
  }

  ingress {
    from_port  			= 5044
    to_port    			= 5044
    protocol   			= "tcp"
    cidr_blocks			= ["0.0.0.0/0"]
    description	                = "Logstash"
  }
  ingress {
    from_port  			= 5601
    to_port    			= 5601
    protocol   			= "tcp"
    cidr_blocks			= ["0.0.0.0/0"]
    description			= "Kibana"
  }
  ingress {
    from_port  			= 9200
    to_port    			= 9200
    protocol   			= "tcp"
    cidr_blocks			= ["0.0.0.0/0"]
    description			= "Elasticsearch"
  }
  ingress {
    from_port  			= 9300
    to_port    			= 9300
    protocol   			= "tcp"
    cidr_blocks			= ["0.0.0.0/0"]
    description			= "Elasticsearch"
  }
  
  ingress {
    from_port  			= 9600
    to_port    			= 9600
    protocol   			= "tcp"
    cidr_blocks			= ["0.0.0.0/0"]
    description			= "Logstash"
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Outbound"
  }
}
