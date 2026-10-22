# A3 — Diagrammi di deployment

*Stato: da fare in F1. Indicare sempre dove stanno i dati (volumi, nodo o zona di PostgreSQL e RabbitMQ).*

## Ambiente A — Kubernetes locale

| Elemento | Valore |
|---|---|
| Cluster | kind o k3d, 1-2 nodi, su Docker Desktop (~8 GB) |
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
