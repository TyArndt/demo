#-------------  devsecops\_security_groups.tf ------------

resource "aws_security_group" "admin_sg" {
  name			= "admin-sg"
  description		= "Security group for access to admin"
  vpc_id		= "${aws_vpc.tools_vpc.id}"

  ingress		{
    from_port		= 22
    to_port		= 22
    protocol		= "tcp"
    cidr_blocks		= ["66.191.109.86/32","63.247.38.201/32"]

}

  ingress		{
    from_port		= 80
    to_port		= 80
    protocol		= "tcp"
    cidr_blocks		= ["0.0.0.0/0"]
}

  egress		{
    from_port		= 0
    to_port		= 0
    protocol		= "-1"
    cidr_blocks		= ["0.0.0.0/0"]
  }

  tags			= {
    Name		= "admin-sg"
  }
}
