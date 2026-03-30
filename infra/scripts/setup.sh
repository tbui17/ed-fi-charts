#!/usr/bin/env bash
set -euo pipefail

GHCR_USER="$1"
GHCR_TOKEN="$2"

echo "=== Installing packages ==="
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
apt-get update -qq
apt-get install -y -qq docker.io docker-compose-v2
systemctl enable --now docker

echo "=== GHCR login ==="
echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GHCR_USER" --password-stdin

echo "=== Starting stack ==="
cd /opt/edfi && docker compose up -d

echo "=== Waiting for db-init to finish ==="
for i in $(seq 1 60); do
  STATUS=$(docker inspect -f '{{.State.Status}}' ed-fi-db-init 2>/dev/null || echo "unknown")
  if [ "$STATUS" = "exited" ]; then
    EXIT_CODE=$(docker inspect -f '{{.State.ExitCode}}' ed-fi-db-init)
    if [ "$EXIT_CODE" = "0" ]; then
      echo "=== db-init completed successfully ==="
      exit 0
    else
      echo "db-init failed with exit code $EXIT_CODE"
      docker logs ed-fi-db-init
      exit 1
    fi
  fi
  echo "Waiting for db-init... ($i/60)"
  sleep 5
done

echo "=== db-init timed out ==="
docker logs ed-fi-db-init
exit 1
