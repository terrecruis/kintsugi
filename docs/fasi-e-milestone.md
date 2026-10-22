# Fasi e milestone

*Pianificazione del progetto: WBS di primo livello (fasi F0-F8), roadmap su 12 settimane e milestone M1-M7 con i criteri di passaggio. Le milestone sono le stesse create su GitHub (Issues → Milestones).*

Ogni milestone è un **punto di controllo**: chiude una o più fasi e ha un criterio verificabile. Se il criterio non è soddisfatto non si passa alla fase successiva.

## Percorso in breve

Progettare e scrivere le previsioni (M1) → costruire l'app (M2) → portarla su Kubernetes (M3) → costruire il banco di misura (M4) → misurare (M5) → ripetere su AWS (M3b, M6) → analizzare e scrivere il report (M7).

## Milestone

| Milestone | Scadenza | Fasi che chiude | Criterio di passaggio | Se non passa |
|---|---|---|---|---|
| **M1** Architettura e previsioni | S2 · 04/11/2026 | F0, F1 | A1-A6, definizioni di misura e previsioni datate | Non si inizia F3 |
| **M2** App minima | S3 · 11/11/2026 | F2 | I quattro criteri di F2 soddisfatti | Non si tocca Kubernetes |
| **M3** Kubernetes locale | S5 · 25/11/2026 | F3 | V1-V3 su Kubernetes; l'harness minimo misura un guasto F1 con risoluzione sotto il secondo | Rivedere il metodo di misura prima di proseguire |
| **M3b** Prova AWS | S6 · 02/12/2026 | F6 (prova) | Cluster creato e distrutto, costi e limiti noti | Ripianificare (o ridurre) subito la fase AWS, non in S9 |
| **M4** Banco di prova | S7 · 09/12/2026 | F4 | I tre criteri di F4 soddisfatti | **Non parte la campagna F5** |
| **M5** Campagna locale | S8 · 16/12/2026 | F5 | Campagna completa con i run validi previsti. **Decisione sulla fase AWS:** sessioni complete, una sola sessione o solo la prova di S6 | Ridurre i guasti opzionali; mai sotto 10 ripetizioni per F1-F4 |
| **M6** Sessioni AWS | S10 · 30/12/2026 | F6 (sessioni) | Sessioni fatte, risorse distrutte, costi annotati | Ridurre a una sola sessione |
| **M7** Consegna | S12 · 13/01/2027 | F7, F8 | Report, diario, repository e orale pronti | — |

## Roadmap

| Fase | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 | S10 | S11 | S12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **F0** Preparazione | ■ | | | | | | | | | | | |
| **F1** Architettura e protocollo | ■ | ■ | | | | | | | | | | |
| **F2** App minima | | ■ | ■ | | | | | | | | | |
| **F3** Kubernetes locale + harness minimo | | | ■ | ■ | ■ | | | | | | | |
| **F4** Osservabilità e banco completo | | | | | ■ | ■ | ■ | | | | | |
| **F5** Campagna locale | | | | | | | ■ | ■ | | | | |
| **F6** AWS (prova, poi sessioni) | | | | | | ■ | | | ■ | ■ | | |
| **F7** Analisi | | | | | | | | | | ■ | ■ | |
| **F8** Report e orale | | | | | | | | | | | ■ | ■ |
| Diario e registro decisioni | ■ | ■ | ■ | ■ | ■ | ■ | ■ | ■ | ■ | ■ | ■ | ■ |
| **Milestone** | | M1 | M2 | | M3 | M3b | M4 | M5 | | M6 | | M7 |

**Inizio di S1: giovedì 22/10/2026.** Ogni settimana va da giovedì a mercoledì; la scadenza di una milestone è l'ultimo giorno della sua settimana. Le stesse scadenze sono impostate sulle milestone di GitHub.

| S1 | S2 | S3 | S4 | S5 | S6 |
|---|---|---|---|---|---|
| 22/10-28/10 | 29/10-04/11 | 05/11-11/11 | 12/11-18/11 | 19/11-25/11 | 26/11-02/12 |

| S7 | S8 | S9 | S10 | S11 | S12 |
|---|---|---|---|---|---|
| 03/12-09/12 | 10/12-16/12 | 17/12-23/12 | 24/12-30/12 | 31/12-06/01 | 07/01-13/01 |

**Attenzione alle feste:** S9-S11 cadono tra il 17/12 e il 06/01. Le sessioni AWS (S9-S10) e l'analisi (S10-S11) sono le attività più esposte: vanno confermate o ripianificate a M5 (16/12) in base alla disponibilità reale dei due.

## Fasi

### F0 — Preparazione · S1 · ~10 h · → M1
**Attività:** repository Git, diario e registro delle decisioni · Docker Desktop (memoria ~8 GB), kind o k3d, kubectl, Helm, JMeter · account AWS con autenticazione a due fattori, utente non amministratore e allarmi di budget · linguaggio (default Python) · ruoli.
**Fatto quando:** `kubectl get nodes` risponde sul cluster locale e l'allarme di budget è attivo.

### F1 — Architettura e protocollo di misura · S1-S2 · ~25 h · → M1
**Attività:** artefatti A1-A6 · definizioni di misura · configurazione di RabbitMQ, politica di riprova, timestamp, posizione dei dati, tabella dei parametri di salute e timeout (ALB compreso) · protocollo sperimentale (domande, matrice, metriche, ripetizioni, regola dei thread, validità dei run) · previsioni.
**Fatto quando:** entrambi sappiamo spiegare ogni diagramma e ogni decisione, e le previsioni sono scritte e committate **prima** di qualsiasi misura (tag `m1`).

### F2 — Applicazione minima e tre versioni · S2-S3 · ~18 h · → M2
**Attività:** API con un endpoint ordini, worker, PostgreSQL · V1, V2, V3 · tempo di servizio regolabile da variabile d'ambiente · ID ordine generato dal client · timestamp di ricezione e di commit nel database · vincolo di unicità e conteggio dei duplicati · RabbitMQ e politica di riprova come da A5 · endpoint di salute · immagini Docker · `docker-compose` per verificare · script che assegna ogni ID a una categoria.
**Fatto quando:**
1. con 100 ordini inviati ne risultano 100 "completati in tempo" in tutte e tre le versioni;
2. senza carico, il tempo end-to-end è pari al tempo di servizio configurato, entro pochi millisecondi;
3. rimandando due volte lo stesso messaggio in V3, il duplicato è rifiutato **e contato**;
4. con il database fermo per 60 s in V3, a fine run gli ordini persi sono 0.

### F3 — Kubernetes locale e harness minimo · S3-S5 · ~38 h · → M3
**Attività:** cluster locale (1-2 nodi) · manifest per API, worker, RabbitMQ, PostgreSQL con volumi persistenti, DB e broker fissati a un nodo · Service/Ingress · controlli di salute (liveness e readiness) · richieste e limiti di risorse · repliche · **harness minimo in S4**: test a ritmo costante con log per richiesta e guasto F1 scriptato.
**Fatto quando:** le tre versioni funzionano su Kubernetes; con un `kubectl delete pod` noto l'harness minimo restituisce downtime e istante di ripristino con risoluzione sotto il secondo.

### F4 — Osservabilità e banco di prova completo · S5-S7 · ~45 h · → M4
**Attività:** Prometheus e Grafana leggeri · piani JMeter a ritmo costante per W1-W3, da riga di comando, thread ≥ ritmo × timeout × 1,5 · script dei guasti F1-F5 che registrano l'istante del guasto · harness completo (reset e verifica dello stato iniziale, struttura del run, raccolta di client, database, eventi e Prometheus, criteri di validità, CSV, ordine casuale) · misura della capacità di base e della soglia di CPU dell'host.
**Fatto quando:**
1. due ripetizioni dello stesso test sono entro una tolleranza dichiarata (es. 10% sulla mediana), anche con un run con guasto in mezzo;
2. durante un guasto il ritmo inviato resta entro ±5%, anche con F4 su V1;
3. F1 su V2 produce un downtime coerente con la previsione A6, oppure la differenza è spiegata.

### F5 — Campagna locale · S7-S8 · ~40 h · → M5
**Attività:** 145 run (9 configurazioni senza guasto × 5 ripetizioni + 10 configurazioni con guasto × 10 ripetizioni; F6 se c'è tempo) · controllo periodico dei dati e della coerenza delle categorie · ogni run scartato e ogni anomalia nel diario · analisi preliminare di RQ1-RQ3.
**Fatto quando:** ogni configurazione ha il numero previsto di run validi e ogni run supera il controllo di coerenza.

### F6 — Fase AWS · prova in S6, sessioni in S9-S10 · ~40 h · → M3b, M6
**Prova (S6):** creare e distruggere il cluster con infrastruttura come codice (eksctl o Terraform) per scoprire limiti, permessi e costi reali.
**Prima delle sessioni:** manifest parametrizzati, tabella dei parametri allineata (ALB compreso), piano delle 2-3 sessioni. Si fanno solo se confermate a M5.
**Sessioni:** EKS su 2-3 zone, ALB, DB e broker in una zona, JMeter su EC2 nella stessa regione · V2 e V3 con W1 e W2, guasti F1, F2, F3, F6.
**Dopo ogni sessione:** distruggere tutto e verificare che non restino risorse a pagamento (load balancer, NAT gateway, volumi, IP elastici).
**Fatto quando:** risultati per RQ4 raccolti con la tabella dei parametri, console AWS pulita, costi annotati.

### F7 — Analisi e confronto con la teoria · S10-S11 · ~22 h · → M7
**Attività:** downtime e richieste fallite previsti contro misurati · disponibilità proiettata in "nove" · mediane, intervalli interquartili, intervalli di confidenza bootstrap · sincrono contro asincrono sul tempo end-to-end · pod pronto contro servizio ripristinato · locale contro AWS · risposta a ogni domanda · cosa non possiamo concludere.
**Fatto quando:** ogni RQ ha una risposta con dati, incertezza e limiti dichiarati.

### F8 — Report, diario e orale · S11-S12 · ~27 h · → M7
**Consegna:** repository · report (architettura A1-A6 → protocollo → risultati → risposte alle RQ → limiti e difficoltà degli strumenti) · diario delle operazioni.
**Fatto quando:** una terza persona, seguendo il README, riesce a rifare un esperimento locale.

## Priorità e piano di taglio

| | |
|---|---|
| **Indispensabile** | A1-A6 · protocollo di misura · V1-V3 su Kubernetes locale · guasti F1-F4 · RQ1-RQ3 · diario e limiti · report |
| **Auspicabile** | Sessioni AWS (RQ4), da confermare a M5 · guasto F5 · guasto F6 |
| **Facoltativo** | RQ5 (autoscaling sulla coda) · Amazon SQS · Online Boutique |

**Ordine dei tagli in caso di ritardo:** guasto F6 → guasto F5 → sessioni AWS ridotte a una (o alla sola prova di S6, con RQ4 dichiarata come non risposta). Non si tagliano mai il protocollo di misura, le 10 ripetizioni dei guasti F1-F4, RQ1-RQ3, A1-A6, diario e limiti.

## Ripartizione del lavoro

| | Persona A | Persona B |
|---|---|---|
| **Responsabile di** | Kubernetes locale e AWS: manifest, cluster, infrastruttura come codice, sessioni AWS | Applicazione, misura (harness, timestamp, validità dei run), osservabilità, analisi statistica |
| **Insieme** | Architettura e protocollo (F1), basi di Kubernetes (F3), esecuzione e analisi (F5, F7), report (F8) | |
