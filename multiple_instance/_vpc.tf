#-------------  devsecops\_vpc.tf ------------

resource "aws_vpc" "tools_vpc" {
  cidr_block 		= "10.8.1.0/24"
  enable_dns_hostnames 	= true
  tags 			= {
    Name = "tools"
  }
}
resource "aws_route_table" "tools_a_routetable" {
  vpc_id		= "${aws_vpc.tools_vpc.id}"
  
  route			{
    cidr_block		= "0.0.0.0/0"
    gateway_id		= "${aws_internet_gateway.tools_igw.id}"
  }  

  tags 			= {
    Name		= "tools-a-routetable"
  }
}

resource "aws_route_table" "tools_b_routetable" {
  vpc_id		= "${aws_vpc.tools_vpc.id}"
  
  route			{
    cidr_block		= "0.0.0.0/0"
    gateway_id		= "${aws_internet_gateway.tools_igw.id}"
  }  

  tags 			= {
    Name		= "tools-b-routetable"
  }
}

resource "aws_internet_gateway" "tools_igw" {
  vpc_id		= "${aws_vpc.tools_vpc.id}"  

  tags			= {
    Name		= "tools"
  }
}

resource "aws_subnet" "tools_subnet_a" {
  cidr_block		= "10.8.1.0/25"
  availability_zone	= "us-east-2a"
  vpc_id		= "${aws_vpc.tools_vpc.id}"
  map_public_ip_on_launch = true

  tags			= {
    Name		= "tools_a"
  }
}

resource "aws_subnet" "tools_subnet_b" {
  cidr_block		= "10.8.1.128/25"
  availability_zone	= "us-east-2b"
  vpc_id		= "${aws_vpc.tools_vpc.id}"
  map_public_ip_on_launch = true

  tags			= {
    Name		= "tools_b"
  }
}

resource "aws_route_table_association" "subnet_a_assoc" {
  subnet_id      = aws_subnet.tools_subnet_a.id
  route_table_id = aws_route_table.tools_a_routetable.id

}

resource "aws_route_table_association" "subnet_b_assoc" {
  subnet_id      = aws_subnet.tools_subnet_b.id
  route_table_id = aws_route_table.tools_b_routetable.id

}