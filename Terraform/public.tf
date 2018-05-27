/*
  Web Servers
*/
resource "aws_security_group" "webserver" {
    name = "vpc_web"
    description = "HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

	ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { # All Traffic
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "WebServerSG"
    }
}

resource "aws_instance" "webserver" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
    subnet_id = "${aws_subnet.us-east-1-public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    ebs_block_device {
     device_name = "/dev/sda1"
     volume_size = "20"
     volume_type = "gp2"
     delete_on_termination = "true"
} 

    tags {
        Name = "Web Server 1"
    }
}


resource "aws_eip" "webserver" {
    instance = "${aws_instance.webserver.id}"
    vpc = true
}
