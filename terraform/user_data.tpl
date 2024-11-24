#!/bin/bash
# Update all installed software packages
yum update -y

# Add the Jenkins repository
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import the Jenkins CI key to allow installation
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Upgrade all the packages to ensure they are up to date
yum upgrade -y

# Install Java (Amazon Corretto 17)
dnf install java-17-amazon-corretto -y

# Install Jenkins
yum install jenkins -y

# Enable Jenkins to start on boot
systemctl enable jenkins

# Start Jenkins service
systemctl start jenkins

# Optional: Check Jenkins service status
systemctl status jenkins
