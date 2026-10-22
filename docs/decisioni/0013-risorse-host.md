# 0013 — Risorse dell'host: dove si sviluppa e dove si misura

**Data:** 2026-10-22 · **Stato:** proposta (da confermare con il collega) · **Autori:** Francesco

## Contesto

Il piano assumeva un Mac da 16 GB con ~8 GB riservati a Docker. In realtà le macchine sono due:

| Macchina | RAM | Note |
|---|---|---|
| Mac di Francesco | 8 GB | Docker Desktop a 6 GB al primo avvio |
| Computer del collega | ≥ 16 GB | sistema operativo e CPU: TODO |

In locale cluster (kind), generatore di carico (JMeter) e sistema operativo condividono la stessa macchina. Se l'host va in swap o satura la CPU, le latenze e i tempi di ripristino misurati riflettono l'host e non l'architettura: è il primo rischio del piano.

Stima indicativa della memoria del cluster (da verificare in F3): nodo di controllo kind ~0,8-1 GB, PostgreSQL + RabbitMQ ~0,4-0,6 GB, Prometheus + Grafana ~0,5-0,7 GB, API e worker ~0,3-0,5 GB, in totale ~2,5-3 GB.

## Alternative considerate

1. **Tutto sul Mac da 8 GB.** Possibile per lo sviluppo, rischioso per la campagna: restano ~3 GB a macOS e JMeter e lo swap è probabile sotto carico.
2. **Tutto sul computer del collega.** Misure pulite, ma un solo membro del gruppo può lavorare su Kubernetes e all'orale entrambi devono saperlo spiegare.
3. **Sviluppo su entrambe, misure sulla macchina da 16 GB.** Ognuno sviluppa e prova in locale; la misura della capacità (F4) e la campagna (F5) si fanno solo sulla macchina più capiente.

## Scelta

Alternativa **3**.

- **Mac da 8 GB (sviluppo):** Docker Desktop a **5 GB**, cluster kind a 2 nodi, Grafana acceso solo quando serve, JMeter con heap limitato (`-Xmx512m`) e solo da riga di comando.
- **Macchina da ≥ 16 GB (sviluppo e misure):** Docker Desktop a **~8 GB**, stessa configurazione del cluster. Qui si fanno la misura della capacità di base, la verifica di M4 e tutta la campagna F5.
- **Una campagna, una macchina:** tutti i run di una campagna si eseguono sulla stessa macchina con la stessa configurazione di Docker; i run fatti altrove non si mescolano con quelli della campagna.
- **L'host si registra:** ogni run salva in `meta.json` nome dell'host, RAM, CPU, memoria assegnata a Docker.

## Compromessi

- Le prove sul Mac da 8 GB servono a verificare che le cose funzionino, non a misurarle: i numeri ottenuti lì non vanno nel report.
- La campagna dipende dalla disponibilità della macchina del collega per ~15 ore di run (più F6): va pianificata in S7-S8.
- Se la macchina del collega non è un Mac, cambiano alcuni dettagli (Docker Desktop su Windows/WSL o Docker nativo su Linux, orologio della macchina virtuale): da verificare in F3 e annotare nel diario.

## Come si verifica

- Nuovo criterio di validità dei run (A1): **nessuno swap dell'host durante il run**, oltre alla soglia di CPU.
- In F4, sulla macchina della campagna: memoria libera e swap registrati durante la misura della capacità di base.
