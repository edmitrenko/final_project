resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id

  tags = merge(local.common_tags, 
    {
       "Environment" = "${local.common_tags["Environment"]}" 
    },
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
  
  dynamic "ingress" {
      for_each      = var.allow_ports
      content {
        from_port   = ingress.value
        to_port     = ingress.value
        protocol    = var.protocol
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


