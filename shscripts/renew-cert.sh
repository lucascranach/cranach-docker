#!/bin/sh
SCRIPT_DIR="$(dirname $0)"
cd $SCRIPT_DIR/..

certbot renew --quiet 
docker-compose stop api
sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d api