data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main" {
  vpc_id   = ""  
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.my_vpc.id
  subnet_id  = ""
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.my_vpc.id
  subnet_id  = ""
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
}


