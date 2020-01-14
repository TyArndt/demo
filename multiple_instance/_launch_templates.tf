data "aws_ami" "latest-awsl2" {
  most_recent = true
  owners = ["137112412989"]

  filter {
    name	= "name"
    values	= ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

data "template_file" "user_data_hw" {
  template = <<EOF
    #! /bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    local=$(curl http://169.254.169.254/latest/meta-data/local-hostname )
		echo "<h1>Hello from $local</h1>" | sudo tee /var/www/html/index.html
        sudo aws s3 cp s3://tal2020brownbagdemo/brownbag.jpg /var/www/html/brownbag.jpg
        sudo echo '<img src="brownbag.jpg">' >> /var/www/html/index.html 
        sudo echo '<meta http-equiv="refresh" content="5" />' >> /var/www/html/index.html 
    sudo service httpd start
    sudo chkconfig httpd on
EOF
}

resource "aws_launch_template" "default_template" {
name            = "default-template"
image_id        = "${data.aws_ami.latest-awsl2.id}"
instance_type		= "t2.micro"
key_name			= "TA_Migration"
disable_api_termination	= false

  iam_instance_profile {
    name = "ec2-s3-instance-profile"
  }


network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    subnet_id			= "${aws_subnet.tools_subnet_a.id}"
    security_groups     =  ["${aws_security_group.admin_sg.id}"]
  }

  user_data = "${base64encode(data.template_file.user_data_hw.rendered)}"

tag_specifications {
    resource_type       =    "instance"
      tags = {
    Name = "demo-instance"
  }
}


}

resource "aws_autoscaling_group" "demo_group" {
  availability_zones = ["us-east-2a"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  target_group_arns   = ["${aws_lb_target_group.demo_tg.arn}"]

  launch_template {
    id      = "${aws_launch_template.default_template.id}"
    version = "$Latest"
  }
}
