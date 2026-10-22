# A3 — Diagrammi di deployment

*Stato: da fare in F1. Indicare sempre dove stanno i dati (volumi, nodo o zona di PostgreSQL e RabbitMQ).*

## Ambiente A — Kubernetes locale

| Elemento | Valore |
|---|---|
| Cluster | kind, 2 nodi, su Docker Desktop |
| Macchina di sviluppo | Mac da 8 GB, Docker a 5 GB (solo prove, nessuna misura nel report) |
| Macchina delle misure | computer del collega, ≥ 16 GB, Docker a ~8 GB (capacità di base, M4, campagna F5) — decisione 0013 |
| PostgreSQL | volume persistente, fissato al nodo: TODO |
| RabbitMQ | volume persistente, fissato al nodo: TODO |
| Generatore di carico | JMeter sul Mac, fuori dal cluster |
| Osservabilità | Prometheus + Grafana in configurazione leggera |

## Ambiente B — AWS

| Elemento | Valore |
|---|---|
| Cluster | EKS, nodi su 2-3 zone |
| Bilanciatore | ALB tramite AWS Load Balancer Controller |
| PostgreSQL / RabbitMQ | volume EBS, una sola zona: TODO |
| Generatore di carico | istanza EC2 nella stessa regione |
