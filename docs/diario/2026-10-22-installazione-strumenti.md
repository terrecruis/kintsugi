# 2026-10-22 — Installazione degli strumenti

**Chi:** Francesco · **Fase:** F0 · **Durata:** ? h · **Issue:** —

## Cosa abbiamo fatto

Verificato gli strumenti già presenti sul Mac e installato quelli mancanti.

| Strumento | Stato iniziale | Azione | Versione |
|---|---|---|---|
| Homebrew | presente | — | |
| Docker Desktop | installato, spento | avviato; memoria a 6 GB, da portare a 5 GB (vedi sotto); Kubernetes integrato disattivato | |
| kubectl | presente | — | v1.32.2 (client) |
| Java | presente | — | 20.0.1 (di sistema) |
| kind | mancante | `brew install kind` | |
| Helm | mancante | `brew install helm` | |
| JMeter | mancante | `brew install jmeter` (porta con sé `openjdk@21`) | 5.6.3 |
| Python 3 | presente | — | |

## Perché

- **kind invece del Kubernetes integrato in Docker Desktop:** kind permette un cluster a più nodi, necessario per fissare PostgreSQL e RabbitMQ a un nodo e, più avanti, per il guasto F6 (perdita di un nodo). Il Kubernetes di Docker Desktop ha un solo nodo.
- **Memoria di Docker:** il piano assumeva un Mac da 16 GB con ~8 GB a Docker. Il Mac di Francesco ha **8 GB in totale**: per ora Docker ha 6 GB, ma restano solo ~2 GB per macOS e JMeter. Il collega ha un computer con ≥ 16 GB: proposta la decisione 0013, cioè sviluppo su entrambe le macchine (Docker a 5 GB sul Mac da 8 GB) e misure solo sulla macchina da ≥ 16 GB. Aggiunto ai criteri di validità di A1 "nessuno swap dell'host durante il run".

## Comandi e configurazione

```bash
for t in brew docker kind kubectl helm jmeter java python3; do printf '%-8s ' $t; command -v $t || echo "MANCA"; done
brew install kind helm jmeter
```

## Risultato

## Problemi e soluzioni

- `/usr/bin/java` esiste sempre su macOS, anche senza un JDK: va verificato con `java -version`.
- `docker` presente ma il motore non risponde finché Docker Desktop non è avviato.

## Limiti dello strumento emersi

- Con 8 GB di RAM, cluster, generatore di carico e sistema operativo condividono una memoria scarsa: se il Mac va in swap, le latenze misurate riflettono l'host e non l'architettura.
