#!/bin/sh
SCRIPT_DIR="$(dirname $0)"
cd $SCRIPT_DIR/..

certbot renew --nginx --quiet --deploy-hook "sudo docker compose exec -f docker-compose.yml -f docker-compose.prod.yml reverse-proxy nginx -s reload"
