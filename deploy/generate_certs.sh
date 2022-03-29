#! /bin/bash

# https://finnian.io/blog/ssl-with-docker-swarm-lets-encrypt-and-nginx/
docker run --rm -p "443:443" -p "80:80" --name letsencrypt \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  certbot/certbot certonly -n \
  -m "adam.stuller@protonmail.com" \
  -d taborbizon.sk \
  --standalone --agree-tos
