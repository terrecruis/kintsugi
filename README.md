<div align="center">

# 🏺 Kintsugi
### Laboratorio di affidabilità e asincronia su Kubernetes e AWS

*Esperimenti ripetibili per misurare come repliche, code asincrone e orchestrazione cambiano l'impatto dei guasti su un servizio distribuito*

![Kubernetes](https://img.shields.io/badge/Kubernetes-kind%20%7C%20EKS-326CE5?logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-EKS%20%2B%20ALB-FF9900?logo=amazonwebservices&logoColor=white)
![RabbitMQ](https://img.shields.io/badge/RabbitMQ-Broker-FF6600?logo=rabbitmq&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-4169E1?logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)
![JMeter](https://img.shields.io/badge/JMeter-Load%20testing-D22128?logo=apachejmeter&logoColor=white)
![Status](https://img.shields.io/badge/Status-F0%20Preparazione-yellow)

**Autori:** Terrecuso Francesco (DE5000005), Vellotti Gianmarco (DE5000041)
**Corso:** Software Project Management & Evolution — Università degli Studi di Napoli Federico II
**Docenti:** Prof. Sergio Di Martino, Prof. Luigi Libero Lucio Starace

</div>

## 1. Obiettivo

Kintsugi è un **servizio di ordini volutamente semplice**, usato come veicolo per esperimenti di affidabilità. Si iniettano guasti controllati (pod spenti, broker e database fermi, ritardi di rete) e si misura come reagiscono tre architetture diverse, confrontando i risultati con **previsioni scritte prima di misurare**.

Oggetto della valutazione è l'**architettura**, non il codice: ogni scelta è documentata come decisione architetturale (ADR) nel documento in [`docs/`](docs/).

| | Domanda di ricerca |
|---|---|
| **RQ1** | Quanto downtime e quante richieste fallite produce ogni guasto passando da 1 a N repliche? |
| **RQ2** | Sincrono contro asincrono: come cambiano tempo end-to-end, ordini persi o duplicati e recupero? |
| **RQ3** | Quanto ci mette il servizio a tornare *effettivamente* operativo dopo un guasto? |
| **RQ4** | I risultati ottenuti in locale si ripetono su AWS? |

> Il nome viene dall'arte giapponese di riparare la ceramica rotta con l'oro, mettendo in evidenza le crepe invece di nasconderle: ogni guasto misurato mostra dove l'architettura cede e come si ricompone.

---

## 2. Architetture a confronto

Le tre versioni sono **configurazioni dello stesso codice** e girano sullo stesso commit, così il confronto resta equo.

| Versione | Funzionamento |
|---|---|
| **V1** — sincrona | L'API riceve l'ordine, lo scrive nel database e risponde. Una sola istanza |
| **V2** — sincrona replicata | Come V1, con N repliche dell'API dietro un bilanciatore |
| **V3** — asincrona | L'API pubblica l'ordine su RabbitMQ e risponde "accettato"; i worker lo scrivono nel database |

```
            ┌──────────────────────┐
 JMeter ───▶│ Service / Ingress    │   (su AWS: ALB)
 (ritmo     └──────────┬───────────┘
 costante)             ▼
            ┌──────────────────────┐   V1/V2: scrive direttamente
            │      API  × N        │─────────────────────────────┐
            └──────────┬───────────┘                             │
                       │ V3: publish + conferma                  ▼
                       ▼                                  ┌──────────────┐
            ┌──────────────────────┐    ┌────────────┐    │  PostgreSQL  │
            │ RabbitMQ (+ DLQ)     │───▶│ Worker × M │───▶│  (volume)    │
            └──────────────────────┘    └────────────┘    └──────────────┘
```

**Punti unici di guasto dichiarati:** PostgreSQL in tutte le versioni, RabbitMQ in V3.

---

## 3. Esperimenti

| Guasto | Descrizione | Versioni |
|---|---|---|
| **F1** | Spegnimento di un pod dell'API | V1, V2, V3 |
| **F2** | Spegnimento di tutti i worker | V3 |
| **F3** | Arresto del broker | V3 |
| **F4** | Arresto del database | V1, V2, V3 |
| **F5** | Ritardo di rete verso il database | V2, V3 |

Il carico è generato a **ritmo costante** (W1 costante, W2 picco, W3 sovraccarico) per evitare la *coordinated omission*. La campagna locale prevede **145 run** in ordine casuale; un sottoinsieme viene ripetuto su **AWS EKS**.

| Ambiente | Infrastruttura |
|---|---|
| **A — locale** | Cluster kind a 2 nodi su Docker Desktop |
| **B — AWS** | EKS su 2–3 zone, ALB, generatore di carico su EC2 nella stessa regione |

---

## 4. Struttura del repository

```
kintsugi/
├── app/                  # API e worker (un solo codice, MODE=sync|async)
├── deploy/
│   ├── k8s/
│   │   ├── base/         # manifest comuni
│   │   └── overlays/     # v1/ v2/ v3/
│   └── aws/              # infrastruttura come codice per EKS
├── harness/
│   ├── jmeter/           # piani di carico W1–W3
│   └── faults/           # script di iniezione dei guasti F1–F6
├── analysis/             # categorizzazione degli ordini e statistiche
├── data/                 # risultati dei run (non versionati)
├── docs/                 # documento di architettura (LaTeX → PDF)
└── report/
    ├── fasi-e-milestone.md
    ├── diario/           # diario delle operazioni
    └── diagrammi/        # grafici dei risultati
```

---

## 5. Guida rapida

### 5.1 Prerequisiti

| Strumento | Uso |
|---|---|
| Docker Desktop | Runtime dei container (5–8 GB di memoria) |
| kind, kubectl, Helm | Cluster Kubernetes locale |
| JMeter | Generazione del carico |
| Python 3.10+ | Applicazione e analisi |
| TeX Live + `latexmk` | Documentazione |

### 5.2 Documento di architettura

```bash
cd docs
make
```

Genera `docs/main.pdf`: architettura, diagrammi, decisioni (ADR), protocollo di misura e previsioni.

### 5.3 Cluster ed esperimenti

*In arrivo con le milestone M2–M4.*

---

## 6. Roadmap

| Milestone | Scadenza | Obiettivo |
|---|---|---|
| **M1** | 04/11/2026 | Architettura, decisioni e previsioni |
| **M2** | 11/11/2026 | Applicazione minima V1–V3 |
| **M3** | 25/11/2026 | V1–V3 su Kubernetes locale |
| **M4** | 09/12/2026 | Banco di prova completo |
| **M5** | 16/12/2026 | Campagna di misura locale |
| **M6** | 30/12/2026 | Sessioni su AWS |
| **M7** | 13/01/2027 | Consegna |

Avanzamento: [milestone su GitHub](https://github.com/terrecruis/kintsugi/milestones).

---

## 7. Contribuire

1. Ogni attività parte da una **issue** assegnata a una milestone.
2. Lo sviluppo avviene su un branch breve (`feat/`, `fix/`, `docs/`, `exp/`).
3. Le modifiche rientrano in `main` tramite **pull request** rivista dall'altro autore.
4. Ogni decisione architetturale diventa un **ADR** in `docs/chapters/decisioni/`.
