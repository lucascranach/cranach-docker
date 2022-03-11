#!/bin/sh
certbot renew --quiet
cd /var/lucascranach/cranach-docker/ && docker-compose stop api
cd /var/lucascranach/cranach-docker/ && sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d api
