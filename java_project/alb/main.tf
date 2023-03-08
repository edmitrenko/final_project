provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket     = "edmitrenko-terraform-remote-state"            // Bucket where to SAVE Terraform State
    key        = "alb/terraform.tfstate"                         // Object name in the bucket to SAVE Terraform State
    region     = "eu-central-1"                                 // Region where bycket created
   }
}
#======================================================================================================================

data "aws_route53_zone" "zone" {
  name = "${var.route53_hosted_zone_name}"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "prod/network/terraform.tfstate"                // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}

data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "prod/sg/terraform.tfstate"                     // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}

data "terraform_remote_state" "servers" {
  backend = "s3"
  config = {
    bucket     = "edmitrenko-terraform-remote-state"             // Bucket from where to GET Terraform State
    key        = "prod/servers/terraform.tfstate"                // Object name in the bucket to GET Terraform state
    region     = "eu-central-1"                                  // Region where bycket created
    }
}

#======================================================================================================================

resource "aws_alb" "alb" {
  name            = "terraform-alb"
  security_groups = ["${data.terraform_remote_state.security_group.outputs.security_group_id_80-tcp}"]    
  subnets         = "${data.terraform_remote_state.network.outputs.prod_public_subnet_ids}"
  tags            = {
    Name          = "terraform-alb"
  }
}

resource "aws_alb_target_group" "tg1" {
  name     = "Target-group-tomcat-node1"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.network.outputs.prod_vpc_id}"
  stickiness {
    type   = "lb_cookie"
    enabled = "true"
  }
  
  health_check {
    path = "/"
#   port = 8081
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"
  }
}

resource "aws_alb_target_group" "tg2" {
  name     = "Target-group-tomcat-node2"
  port     = 8082
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.network.outputs.prod_vpc_id}"
  stickiness {
    type    = "lb_cookie"
    enabled = "true"
  }
  
  health_check {
    path = "/"
#   port = 8082
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "tg1" {
  count            = "${length([data.terraform_remote_state.servers.outputs.prod-tomcat1_id, data.terraform_remote_state.servers.outputs.prod-tomcat1_id])}"
  target_group_arn = aws_alb_target_group.tg1.arn
# target_id        = data.terraform_remote_state.servers.outputs.prod-tomcat1_id
  target_id        = "${element([data.terraform_remote_state.servers.outputs.prod-tomcat1_id, data.terraform_remote_state.servers.outputs.prod-tomcat2_id], count.index)}"
  port             = "${element(["8081", "8082"], count.index)}"
}

resource "aws_lb_target_group_attachment" "tg2" {
  count            = "${length([data.terraform_remote_state.servers.outputs.prod-tomcat1_id, data.terraform_remote_state.servers.outputs.prod-tomcat1_id])}"
  target_group_arn = aws_alb_target_group.tg2.arn
# target_id        = data.terraform_remote_state.servers.outputs.prod-tomcat1_id
  target_id        = "${element([data.terraform_remote_state.servers.outputs.prod-tomcat1_id, data.terraform_remote_state.servers.outputs.prod-tomcat2_id], count.index)}"
  port             = "${element(["8081", "8082"], count.index)}"
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_alb_target_group.tg1.arn
      }

      target_group {
        arn = aws_alb_target_group.tg2.arn
      }
 
      stickiness {
        enabled  = true
        duration = 1
      }
    }
  }    
}

resource "aws_route53_record" "terraform" {
  zone_id 		   = "${data.aws_route53_zone.zone.zone_id}"
  name    		   = "tomcat1.${var.route53_hosted_zone_name}"
  type    		   = "A"
  alias {
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
    evaluate_target_health = true
  }
}
