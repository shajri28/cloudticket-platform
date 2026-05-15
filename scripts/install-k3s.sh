#!/bin/bash
# ============================================================
# cloudticket-platform — k3s bootstrap script
# Runs automatically on EC2 first boot via user_data
# ============================================================

set -e

echo "==> Updating system packages..."
apt-get update -y
apt-get upgrade -y

echo "==> Installing dependencies..."
apt-get install -y curl wget git unzip

echo "==> Installing Docker..."
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker

echo "==> Installing k3s..."
curl -sfL https://get.k3s.io | sh -s - \
  --write-kubeconfig-mode 644 \
  --disable traefik

echo "==> Waiting for k3s to be ready..."
sleep 30
k3s kubectl get nodes

echo "==> Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "==> Done! k3s is running."
echo "==> Kubeconfig is at: /etc/rancher/k3s/k3s.yaml"
