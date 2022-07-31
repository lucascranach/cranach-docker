#!/bin/sh
SCRIPT_DIR="$(dirname $0)"
cd $SCRIPT_DIR/..

certbot renew --quiet --deploy-hook "sudo docker compose -f docker-compose.yml -f docker-compose.prod.yml exec reverse-proxy nginx -s reload"
