resource "aws_iam_role" "sonarqube_server_instance_role" {
  name = "sonarqube-server-instance-role"
  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
  )

  tags = {
    Name      = "CloudWatch demo"
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "sonarqube_server_policy_attachment" {
  role = aws_iam_role.sonarqube_server_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "sonarqube_server_instance_profile" {
  name = "sonarqube-server-instance-profile"
  role = aws_iam_role.sonarqube_server_instance_role.name

  tags = {
    Name      = "CloudWatch demo"
    Terraform = "true"
  }
}

resource "aws_launch_template" "cw_demo_lt" {
  name_prefix   = "cw-demo-lt-"
  image_id      = var.image_id
  instance_type = var.cw_demo_instance_type
  key_name      = "cw-demo"

  vpc_security_group_ids = var.vpc_security_group_ids

  iam_instance_profile {
    arn = aws_iam_instance_profile.sonarqube_server_instance_profile.arn
  }

  user_data = "${base64encode(<<EOF
${var.init_file}
EOF
  )}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 30
      volume_type           = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "CloudWatch demo"
      Terraform = "true"
    }
  }
}

resource "aws_autoscaling_group" "cw_demo_asg" {
  name             = "cw-demo-asg"
  max_size         = 1
  min_size         = 0
  desired_capacity = 0
  # TODO: uncomment this
  #protect_from_scale_in = true
  # TODO: figure out health check
  #health_check_type = "EC2"
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.cw_demo_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}
