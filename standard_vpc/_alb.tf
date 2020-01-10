/*
data "aws_instances" "demo_instances" {
    instance_tags = {
        Name    = "demo-instance"
    }

    
}
*/

resource "aws_lb" "demo_lb" {
    name        = "demo-loadbalancer"
    internal    = false
    load_balancer_type  = "application"
    security_groups     = ["${aws_security_group.admin_sg.id}"]
    subnets     = ["${aws_subnet.tools_subnet_a.id}","${aws_subnet.tools_subnet_b.id}"]

      
 }

resource "aws_lb_target_group" "demo_tg" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.tools_vpc.id}"
}





 resource "aws_lb_listener" "demo_lb_listener" {
  load_balancer_arn = "${aws_lb.demo_lb.arn}"
    port                = "80"
    protocol            = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn    = "${aws_lb_target_group.demo_tg.arn}"
  }
}

/*
resource "aws_lb_target_group_attachment" "demo1_tg_attach" {
  count    = "${length(data.aws_instances.demo_instances.ids)}"
  target_group_arn = "${aws_lb_target_group.demo_tg.arn}"
  target_id        = "${data.aws_instances.demo_instances.ids[count.index]}"
  port             = 80

  
} */



output loadbalancername {
    value   = aws_lb.demo_lb.dns_name
}