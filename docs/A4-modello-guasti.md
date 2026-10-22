# A4 — Modello dei guasti

*Stato: da fare in F1. Nessun ripristino manuale: si osserva quello automatico.*

| | Guasto | Come si inietta | Cosa succede | Chi ripristina | Quando è ripristinato | MTTR atteso | Versioni |
|---|---|---|---|---|---|---|---|
| **F1** | Spegnere 1 pod dell'API | `kubectl delete pod` | | Kubernetes | Definizione di A1 | vedi A6 | V1, V2, V3 |
| **F2** | Spegnere tutti i worker | | | Kubernetes | | | V3 |
| **F3** | Fermare il broker | | | Kubernetes + riconnessione di API e worker | | | V3 |
| **F4** | Fermare il database | | | Kubernetes + riprova dell'applicazione | | | V1, V2, V3 |
| **F5** | Ritardo di rete verso il DB | Toxiproxy | | nessuno (degrado) | | | V2, V3 |
| *F6* | *Perdita di un nodo con solo API e worker* | | | *Kubernetes dopo l'attesa di eviction* | | | *V2, V3* |
