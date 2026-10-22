# Dati dei run

I risultati dei run non sono versionati in git (vedi `.gitignore`): sono troppo grandi e si rigenerano.

Ogni run salva una cartella `data/<ambiente>/<run-id>/` con:

| File | Contenuto |
|---|---|
| `meta.json` | configurazione (versione, carico, guasto, ripetizione), **hash del commit**, istante del guasto, esito dei criteri di validità |
| `client.csv` | log per richiesta di JMeter: istante di invio, ID ordine, esito, tempo di risposta |
| `db.csv` | ordini salvati: ID, istante di ricezione (API), istante di commit (database) |
| `events.csv` | eventi Kubernetes: pod terminato, creato, pronto |
| `prometheus.csv` | lunghezza ed età della coda, riprove, dead-letter, CPU e memoria |
| `categorie.csv` | categoria assegnata a ogni ID ordine (§ 5.3) |

L'archivio della campagna si conserva fuori dal repository (es. allegato a una release GitHub o su un drive condiviso), indicando qui dove si trova.
