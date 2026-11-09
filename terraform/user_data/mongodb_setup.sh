
#!/bin/bash
set -euxo pipefail

exec > >(tee -a /var/log/mongodb-setup.log) 2>&1

echo "Starting MongoDB server setup..."

# Add the MongoDB 8.0 repository
cat > /etc/yum.repos.d/mongodb-org-8.0.repo <<'EOF'
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
EOF

# Install MongoDB
yum install -y mongodb-org

# Enable and start MongoDB
systemctl enable mongod
systemctl start mongod

# Verify MongoDB service
systemctl status mongod --no-pager

echo "MongoDB server setup completed."

