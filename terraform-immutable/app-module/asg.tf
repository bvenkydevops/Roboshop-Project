resource "aws_launch_template" "template" {
  name                   = "${var.COMPONENT}-${var.ENV}"
  image_id               = data.aws_ami.ami.id
  instance_type          = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.sg.id]
  instance_market_options {
    market_type = "spot"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.COMPONENT}-${var.ENV}"
    }
  }

  user_data = filebase64("${path.module}/env-${var.ENV}.sh")
}

resource "aws_autoscaling_group" "asg" {
  name                = "${var.COMPONENT}-${var.ENV}"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS
  target_group_arns   = [aws_lb_target_group.tg.arn]
  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.COMPONENT}-${var.ENV}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Monitor"
    value               = "yes"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asg-policy-for-cpu" {
  name                   = "${var.COMPONENT}-cpu"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}