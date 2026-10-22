# A2 — Diagrammi dei componenti

*Stato: da fare in F1. Sorgenti dei diagrammi in `diagrammi/`.*

## V1 — Sincrona, 1 istanza

```
Client ──► Service ──► API ──► PostgreSQL
```

## V2 — Sincrona, N repliche

```
Client ──► Service/Ingress ──► API ×N ──► PostgreSQL
```

## V3 — Asincrona

```
Client ──► Service/Ingress ──► API ×N ──(publish con conferma)──► RabbitMQ ──► Worker ×M ──► PostgreSQL
                                                                     └── dead-letter
```

**Punti unici di guasto dichiarati:** PostgreSQL (tutte le versioni), RabbitMQ (V3).

## Per ogni componente

| Componente | Responsabilità | Con stato? | Repliche |
|---|---|---|---|
| API | | no | |
| Worker | | no | |
| RabbitMQ | | sì | 1 |
| PostgreSQL | | sì | 1 |
