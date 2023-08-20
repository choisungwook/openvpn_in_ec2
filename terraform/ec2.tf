resource "aws_instance" "openvpn" {
  instance_type          = "t4g.nano"
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = aws_subnet.public["public-a"].id
  vpc_security_group_ids = [aws_security_group.openvpn.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  user_data              = file("openvpn_userdata.sh")
}

resource "aws_instance" "nginx" {
  instance_type          = "t4g.nano"
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = aws_subnet.private["private-a"].id
  vpc_security_group_ids = [aws_security_group.nginx.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  user_data              = file("nginx_userdatah.sh")

  tags = {
    Name    = "terraform-test-nginx"
    Project = "openvpn"
  }

  depends_on = [
    aws_nat_gateway.main
  ]
}

resource "aws_security_group" "openvpn" {
  name        = "terraform-test-openvpn"
  description = "openvpn"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "openvpn server"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "nginx" {
  name        = "terraform-test-nginx"
  description = "nginx"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "icmp"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
