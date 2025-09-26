#!/bin/bash
# Update system
sudo yum update -y

# Install Docker
sudo yum install -y docker

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Add ec2-user to Docker group
sudo usermod -aG docker ec2-user

# Install / ensure SSM agent is running. This will be used to access our instance provisioned in the private subnet
sudo yum install -y amazon-ssm-agent       # optional for Amazon Linux 2, already installed
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent


# Pre-pulling the image
docker pull jackedu/weblog_repo:latest

# Run the Docker container
sudo docker run -d -p 80:80 --restart always --name weblog_container jackedu/weblog_repo:latest

# Confirm Docker version
docker --version
