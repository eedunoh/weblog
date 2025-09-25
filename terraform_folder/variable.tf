
variable "region" {
  default = "eu-north-1"
  description = "aws region"
  type = string
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
    description = "vpc cidr block"
    type = string
}

variable "vpc_name" {
    default = "weblog_vpc"
    description = "aws vpc name"
    type = string
}

variable "launch_template_name" {
    default = "weblog_launch_template"
    description = "launch template name"
    type = string
}


variable "ec2_key_name" {
    default = "webapp1key"
    description = "ec2 key name"
    type = string
}

variable "alb_name" {
    default = "weblog-alb"
    description = "alb name"
    type = string
}

variable "aws_cognito_user_pool_name" {
    default = "weblog_user_pool"
    description = "cognito user pool name"
    type = string
}

variable "aws_cognito_user_pool_client_name" {
    default = "my-weblog-app"
    description = "cognito user pool client name"
    type = string
}