# Kintsugi

**Laboratorio di affidabilità e asincronia su Kubernetes e AWS**

> *Kintsugi* è l'arte giapponese di riparare la ceramica rotta con l'oro, mettendo in evidenza le crepe invece di nasconderle. Qui il servizio si rompe di proposito: ogni guasto iniettato e ogni ripristino misurato mostrano dove l'architettura cede e come si ricompone.

Progetto d'esame di **Software Project Management & Evolution** (Federico II, Traccia 4).

Obiettivo: misurare, con esperimenti ripetibili, come repliche, coda asincrona e orchestrazione cambiano l'impatto dei guasti, le prestazioni e il recupero di un servizio di ordini, e confrontare le misure con le previsioni scritte prima.

| Versione | Funzionamento |
|---|---|
| **V1** | Sincrona, 1 istanza dell'API |
| **V2** | Sincrona, N repliche dietro il bilanciatore |
| **V3** | Asincrona: l'API pubblica su RabbitMQ, i worker scrivono su PostgreSQL |

V1, V2 e V3 sono **configurazioni dello stesso codice** (variabile `MODE` + overlay Kubernetes), non branch: le tre versioni devono girare sullo stesso commit perché il confronto sia equo.

## Struttura

```
app/            api/ e worker/ (un solo codice; MODE=sync|async)
deploy/
  k8s/base/     manifest comuni (API, worker, RabbitMQ, PostgreSQL, Service)
  k8s/overlays/ v1/ v2/ v3/ (differenze tra le versioni)
  aws/          infrastruttura come codice per EKS (fase F6)
harness/
  jmeter/       piani di carico W1-W3 a ritmo costante
  faults/       script dei guasti F1-F6 (registrano l'istante del guasto)
analysis/       categorizzazione degli ordini, statistiche, grafici
data/           risultati dei run (non versionati, vedi data/README.md)
docs/
  A1-requisiti-e-misure.md   definizioni di misura
  A2-componenti.md           diagrammi dei componenti V1-V3
  A3-deployment.md           ambienti A (locale) e B (AWS)
  A4-modello-guasti.md       guasti, chi ripristina, MTTR atteso
  A5 = decisioni/            registro delle decisioni + parametri.md
  A6-previsioni.md           previsioni datate, scritte prima di misurare
  diario/                    diario di bordo, una voce per sessione
  diagrammi/                 sorgenti e immagini dei diagrammi
scripts/        utilità del repository (setup GitHub, ...)
```

## Flusso di lavoro

1. Ogni attività nasce come **Issue** su GitHub, assegnata a una **Milestone** (M1-M7).
2. Si apre un branch breve dal `main`: `feat/<n-issue>-descrizione`, `fix/...`, `docs/...`, `exp/...`.
3. Si apre una **Pull Request** che chiude l'issue (`Closes #n`); l'altra persona la rivede prima del merge.
4. `main` è sempre funzionante. Ogni milestone raggiunta riceve un tag (`m1`, `m2`, ...).
5. Ogni sessione di lavoro lascia una voce nel diario; ogni scelta rilevante passa dal registro delle decisioni.

Le **previsioni (A6) vanno committate prima di qualsiasi misura**: la data del commit ne è la prova.

## Prerequisiti (F0)

- Docker Desktop con memoria limitata a ~8 GB
- kind (o k3d), kubectl, Helm
- JMeter (uso da riga di comando)
- Python 3
- Account AWS con autenticazione a due fattori, utente non amministratore, allarmi di budget

F0 è completa quando `kubectl get nodes` risponde sul cluster locale e l'allarme di budget è attivo.

## Riprodurre un esperimento

*Da completare in F8: una terza persona deve poter rifare un esperimento locale seguendo solo questa sezione.*
