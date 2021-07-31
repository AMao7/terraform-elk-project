 resource "aws_instance" "elk" {
    ami = "${(var.AMI)}"
    instance_type = "t2.micro"
 
 # VPC
    subnet_id = "${aws_subnet.ELK-subnet-public.id}"
    vpc_security_group_ids = ["${aws_security_group.ELK-sg.id}"]
    key_name = "devops-elk"
    

    }


