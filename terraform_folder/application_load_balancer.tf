resource "aws_lb" "app_alb" {
  name               = var.alb_name
  internal           = false                          # internal = false → The ALB is public-facing (accessible via the internet).
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]


  enable_deletion_protection = false
}


resource "aws_lb_target_group" "alb_tg" {
  name     = "AlbTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id


    # Without this, the ALB won’t know if the instances are healthy!
    # The ALB does NOT replace unhealthy instances—it just stops sending traffic to them.

   health_check {
    path                = "/health"
    interval            = 30    # The ALB performs a health check every 30 seconds.
    timeout             = 5     # The ALB waits 5 seconds for a response before marking the check as failed.
    healthy_threshold   = 2      # The target (EC2 instance) must pass the health check 2 times in a row to be marked as healthy.
    unhealthy_threshold = 4      # The target must fail the health check 2 times in a row to be marked as unhealthy.
    }

}


# Without this listener, the ALB won’t know how to handle incoming requests.
# The ALB itself doesn’t forward traffic unless you explicitly tell it to forward requests to a Target Group.
# The listener defines which port (e.g., 80 for HTTP, 443 for HTTPS) and which Target Group the ALB should send traffic to

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.issued_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}



# HTTP listener redirecting to HTTPS. It listens on port 80 (HTTP) and redirects all traffic to HTTPS (port 443) with a permanent redirect.
# This ensures users typing http:// are automatically sent to https://
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



output "alb_target_group_id" {
  value = aws_lb_target_group.alb_tg.arn
}

output "app_alb_id" {
  value = aws_lb.app_alb.arn
}