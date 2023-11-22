resource "aws_security_group" "mongodb" {
  name        = "mongodb-${var.ENV}"
  description = "mongodb-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      description      = "MONGODB"
      from_port        = 27017
      to_port          = 27017
      protocol         = "tcp"
      cidr_blocks      = local.ALL_CIDR
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = local.ALL_CIDR
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "mongodb-${var.ENV}"
  }
}

resource "aws_spot_instance_request" "mongodb" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.MONGODB_INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.mongodb.id]
  wait_for_fulfillment   = true
  subnet_id              = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS[0]
  tags = {
    Name = "mongodb-${var.ENV}"
  }
}

resource "aws_ec2_tag" "mongodb" {
  resource_id = aws_spot_instance_request.mongodb.spot_instance_id
  key         = "Name"
  value       = "mongodb-${var.ENV}"
}

resource "aws_route53_record" "mongodb" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTEDZONE_ID
  name    = "mongodb-${var.ENV}"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.mongodb.private_ip]
}

resource "null_resource" "mongodb-setup" {
  provisioner "remote-exec" {
    connection {
      host     = aws_spot_instance_request.mongodb.private_ip
      user     = local.ssh_user
      password = local.ssh_pass
    }
    inline = [
      "ansible-pull -U https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps60/_git/ansible roboshop-pull.yml -e ENV=${var.ENV} -e COMPONENT=mongodb -e APP_VERSION="
    ]
  }
}