resource "aws_key_pair" "KeyPair" {
  key_name   = "IB07441_EC2_SSH_Key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqLao0WnxsUcJAq5KgUY5sxjsigNQtia+0DIJ05E9Ad1uKgYCtdGlyrSRI/4lgW9sqbIKruz4e8WgnhqxgVMOTro5Z6c0GbRUlS6cS2QLpTQGAyRBZWBY76QbhI6T1rk7L3KHLnknfIU+gUkDDA31dMb3xaf9mjHVDzgMNY/cDZjirNx7D9bnhW1BnMhQ9Y4E3x+pdVO1YrMnm4v/68KkWjIiCdQOtOGg+uijllCtBFL2DGByhIB/xhhVhHFvLP8BwWzg0ftbA2PaUopopXZhHoWA39bFiGwt44nIIFCk/gSMEAyRq3mxPwAMTY2RQSAx/IPjU6o1xkmZ6ao8jC5Vr 07441@SKCC20N01233"
}

variable default_key_name {
  default = "IB07441_EC2_SSH_Key"
}

resource "aws_instance" "Instance_SpringBoot_AWS_01" {
  ami = "ami-9bec36f5" #ap-northeast-2
  availability_zone = aws_subnet.Subnet_Public01.availability_zone
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.IAMInstanceProfile.id
  key_name = var.default_key_name
  vpc_security_group_ids = [
    aws_default_security_group.DefaultSecurityGroup.id,
    aws_security_group.SecurityGroup.id
  ]
  subnet_id = aws_subnet.Subnet_Public01.id
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
yum upgrade
yum install -y aws-cli
yum install -y git
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
chmod +x ./install
./install auto
yum remove -y java-1.7.0-openjdk
yum install -y java-1.8.0-openjdk-devel.x86_64
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime
EOF

  tags = {
    Name = "IB07441-Instance-SpringBoot-AWS"
  }
}