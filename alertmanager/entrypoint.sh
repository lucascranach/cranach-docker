#!/bin/sh

echo "[alertmanager entrypoint] Rendering config from template..."
envsubst < /etc/alertmanager/alertmanager.tpl.yml > /alertmanager-config/alertmanager.yml

echo "[alertmanager entrypoint] Starting Alertmanager..."
exec /bin/alertmanager --config.file=/alertmanager-config/alertmanager.yml --storage.path=/alertmanager-data