module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = var.vpc_azs 
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets

  enable_nat_gateway = true

  tags = merge({"Name" = "demo-vpc"}, var.common_tags)
    
}


resource "aws_security_group" "vpc_communication" {
  name        = "allow_vpc_traffic"
  description = "Allow all vpc inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

module "autoscale_group" {
  source = "git::https://github.com/cloudposse/terraform-aws-ec2-autoscale-group.git?ref=master"

  name			      = "tomcat_demo_asg"
  image_id                    = "ami-050f7e14d7fc1c18a"
  instance_type               = "t2.micro"
  security_group_ids          = [ aws_security_group.vpc_communication.id ]
  subnet_ids                  = module.vpc.private_subnets
  health_check_type           = "EC2"
  min_size                    = 3
  max_size                    = 6
  wait_for_capacity_timeout   = "5m"
  load_balancers              = [ aws_elb.demo.id ]
  key_name		      = var.key_name
  associate_public_ip_address = true

  tags = merge({"Name" = "demo-vpc"}, var.common_tags) 
  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "70"
  cpu_utilization_low_threshold_percent  = "20"
}

resource "aws_elb" "demo" {
  security_groups = [ "${aws_security_group.elb_sg.id}" ]
  depends_on = [ module.vpc ]
  subnets = "${module.vpc.public_subnets}"
  # availability_zones = var.azs_name
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}

## Security Group for ELB
resource "aws_security_group" "elb_sg" {
  name = "apache_demo_elb_sg"
  vpc_id = "${module.vpc.vpc_id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#
