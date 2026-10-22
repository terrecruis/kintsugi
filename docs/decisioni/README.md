# A5 — Registro delle decisioni

Una pagina per decisione, numerata (`0001-titolo.md`), scritta copiando `_template.md`. Una decisione non si cancella: se cambia, se ne scrive una nuova che la sostituisce e si aggiorna lo stato della vecchia. Ogni aggiunta di scope passa da qui.

## Indice

| # | Decisione | Stato |
|---|---|---|
| 0001 | Sincrono contro asincrono e loro compromessi | da scrivere |
| 0002 | Configurazione di RabbitMQ (code durevoli, messaggi persistenti, publisher confirms, ack manuale dopo il commit, dead-letter) | da scrivere |
| 0003 | Politica di riprova dei worker (backoff, durata totale > fermo più lungo di F4) | da scrivere |
| 0004 | Idempotenza (consegna almeno una volta, vincolo di unicità, duplicati contati) | da scrivere |
| 0005 | Timestamp di ricezione e di commit da orologi del cluster | da scrivere |
| 0006 | Dati: PostgreSQL e RabbitMQ singoli, volume persistente, fissati a nodo e zona | da scrivere |
| 0007 | Repliche e parametri dei controlli di salute identici nei due ambienti (vedi `../parametri.md`) | da scrivere |
| 0008 | Timeout del client identico per tutte le versioni | da scrivere |
| 0009 | Generatore di carico su AWS: EC2 nella stessa regione | da scrivere |
| 0010 | Connessioni al database: (repliche API + worker) × pool < max_connections | da scrivere |
| 0011 | Linguaggio dell'applicazione (default Python) | da scrivere |
| 0012 | Un solo repository, V1-V3 come configurazioni e non come branch | da scrivere |
| [0013](0013-risorse-host.md) | Risorse dell'host: sviluppo su entrambe le macchine, misure su quella da ≥ 16 GB | proposta |
