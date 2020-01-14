#---------- devsecops/_instances.tf -------------

data "aws_ami" "latest-awsl2" {
  most_recent = true
  owners = ["137112412989"]

  filter {
    name	= "name"
    values	= ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}



resource "aws_instance" "default_instance" {
    ami				= "${data.aws_ami.latest-awsl2.id}"
    instance_type		= "t2.micro"
    key_name			= "TA_Migration"
    vpc_security_group_ids	= ["${aws_security_group.admin_sg.id}"]
    subnet_id			= "${aws_subnet.tools_subnet_a.id}"
    disable_api_termination	= false
    associate_public_ip_address = true

    user_data = <<EOF
		#! /bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    local=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
		echo "<h1>Hello from $local</h1>" | sudo tee /var/www/html/index.html
    sudo service httpd start
    sudo chkconfig httpd on
	  EOF


  tags			= {
    Name		= "default-instance"
  }
}
