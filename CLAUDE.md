# cranach-docker

Docker-Setup für das Lucas Cranach Archive.

## Umgebungen

| Umgebung | Server | Branch |
|---|---|---|
| Prod | `mivs02.gm.fh-koeln.de` | `master` |
| Dev | `mivs03.gm.fh-koeln.de` | `integration` |

Deployment via GitHub Actions (SCP + SSH). Lokale Entwicklung läuft ohne `docker-compose.prod.yml`.

## Stack

- **Reverse Proxy:** Nginx (SSL-Terminierung via Let's Encrypt)
- **API:** Node.js (`cranach-api`)
- **Datenbank:** Elasticsearch + Kibana
- **Monitoring:** Prometheus · Grafana · Alertmanager · node-exporter · elasticsearch-exporter · blackbox-exporter

## Starten

```shell
# Lokal / Dev
docker compose up -d

# Prod-Server
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## Git

Commits nach [Conventional Commits](https://www.conventionalcommits.org/) formatieren:
```
<type>(<scope>): <beschreibung>
```
Typen: `feat`, `fix`, `chore`, `docs`, `refactor`, `ci`

## Hinweise

- `.env` aus `.env.example` ableiten und befüllen
- Kibana benötigt einen manuell generierten Service-Account-Token (siehe README)
- Nach Änderungen am Alertmanager: `docker compose build alertmanager`
- Detaillierte Analyse und offene Vorhaben: `CLAUDE.local.md` (gitignored)
