 resource "aws_instance" "elk" {
    ami = "${(var.AMI)}"
    instance_type = "t2.medium"
 
 # VPC
    subnet_id = "${aws_subnet.ELK-subnet-public.id}"
    vpc_security_group_ids = ["${aws_security_group.ELK-sg.id}"]
    key_name = "devops-elk"
    user_data = "${data.template_file.user_data.rendered}"

    }


data "template_file" "user_data" {
  template = "${file("templates/user_data.tpl")}"

}