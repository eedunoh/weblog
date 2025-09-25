resource "aws_launch_template" "weblog_lt" {
    name = var.launch_template_name

    image_id = "ami-016038ae9cc8d9f51"    # Amazon Linux 2023 AMI

    instance_initiated_shutdown_behavior = "terminate"

    instance_type = "t3.micro"

    key_name = var.ec2_key_name

    network_interfaces {
        associate_public_ip_address = false  # application will be deployed in the private subnet
        security_groups = [aws_security_group.ec2_sg.id]
    }

    # IAM instance profile (needed for app running on ec2)
    iam_instance_profile {
      name = aws_iam_instance_profile.ec2_instance_profile.name
    }

    credit_specification {
        cpu_credits = "standard"
    }

    user_data = base64encode(file("user_data.sh"))

    tags = {
      Name = "weblog-Server"
    }
}


output "launch_template_id" {
  value = aws_launch_template.weblog_lt.id
}
