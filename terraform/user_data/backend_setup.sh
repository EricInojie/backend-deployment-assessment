
#!/bin/bash
set -euxo pipefail

exec > >(tee -a /var/log/backend-setup.log) 2>&1

echo "Starting backend server setup..."

# Install Docker
amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker

# Add EC2 user to Docker group
usermod -aG docker ec2-user

# Install Docker Compose plugin
mkdir -p /usr/local/lib/docker/cli-plugins

curl -SL \
  https://github.com/docker/compose/releases/download/v2.29.7/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Verify installations
docker --version
docker compose version

echo "Backend server setup completed."
