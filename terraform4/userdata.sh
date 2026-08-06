#!/bin/bash
set -euxo pipefail

# install docker (same as terraform3)
curl -fsSL https://get.docker.com | sh
systemctl enable --now docker

# make ssm-user able to manage docker
id ssm-user &>/dev/null || useradd -m ssm-user
usermod -aG docker ssm-user

# official Rackula self-hosting compose (persist) from SELF-HOSTING.md
mkdir -p /home/ssm-user/rackula/data
cd /home/ssm-user/rackula
curl -fsSL https://raw.githubusercontent.com/RackulaLives/Rackula/main/deploy/docker-compose.persist.yml -o docker-compose.yml

# API container runs as UID 1001 and needs write access to ./data
chown -R ssm-user:ssm-user /home/ssm-user/rackula
chown 1001:1001 /home/ssm-user/rackula/data

# start Rackula: web UI on port 8080, API on 3001 (internal)
docker compose up -d
