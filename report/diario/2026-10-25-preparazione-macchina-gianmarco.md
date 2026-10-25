# 2026-10-25 — Preparazione della macchina di misura e problema sul piazzamento nel cluster

**Chi:** Gianmarco · **Fase:** F0/F1 · **Durata:** 1 h · **Issue:** #7, #13

## Cosa abbiamo fatto

Preparato il MacBook Air M5 da 16 GB, che D0013 indica come unica macchina per le misure ufficiali, e creato lo stesso cluster di Francesco.

| Voce | Valore |
|---|---|
| Computer | MacBook Air, chip Apple M5, 10 core, 16 GB di RAM |
| Docker Desktop | Docker 28.5.2, memoria 7,75 GiB (8.322.101.248 byte), 10 CPU; Kubernetes integrato disattivato |
| kind | v0.33.0 |
| kubectl | v1.37.1 (Kustomize v5.8.1) |
| Helm | v4.3.1 |
| JMeter | 5.6.3 (con OpenJDK 21, installato come dipendenza) |
| Immagine dei nodi | `kindest/node:v1.37.0` (Debian 13, containerd 2.3.4, kernel 6.12.54-linuxkit, arm64) |

Verificato prima che le porte 8080 e 3000 fossero libere, creato il cluster da `deploy/k8s/kind-cluster.yaml` e controllato nodi e pod di sistema.

Analizzato il file `kind-cluster.yaml` e i suoi commenti e individuato un problema di progetto, segnalato nell'issue #13.

## Perché

D0013 richiede che le specifiche della macchina di misura siano registrate prima della prima misura e non cambino durante la campagna. Con lo stesso file e la stessa immagine dei nodi il cluster è identico a quello dell'altra macchina.

Il problema del piazzamento va chiarito prima di scrivere i manifest, perché da esso dipendono gli esperimenti sul guasto di macchina (F6) e la protezione che V4 offre davvero (D0006).

## Comandi e configurazione

```bash
lsof -nP -iTCP:8080 -iTCP:3000 -sTCP:LISTEN
brew install kind helm jmeter kubectl
kubectl version --client
kind version
jmeter --version
helm version --short
docker info --format 'Docker {{.ServerVersion}}, memoria {{.MemTotal}} byte, CPU {{.NCPU}}'
git switch main && git pull
kind create cluster --name kintsugi --config deploy/k8s/kind-cluster.yaml
kubectl get nodes -L kintsugi/ruolo -o wide
kubectl get pods -A -o wide
docker stats --no-stream
gh issue create -R terrecruis/kintsugi --title "Cluster: guasto di macchina non coperto e regole di piazzamento dei pod incerte" --label "bug,F1-architettura,decisione,limite-strumento" --milestone "M1 - Architettura e previsioni" --body-file -
```

## Risultato

- Tre nodi `Ready`, tutti alla versione v1.37.0: `kintsugi-control-plane`, `kintsugi-worker` (etichetta `dati`), `kintsugi-worker2` (etichetta `calcolo`).
- Porte esposte solo su 127.0.0.1: 8080 → 30080 (API) e 3000 → 30030 (Grafana).
- Tutti i 13 pod di sistema `Running`, 0 riavvii.
- Memoria a cluster vuoto: control plane 681,9 MiB, worker 151,8 MiB, worker2 145 MiB, circa 979 MiB in tutto. Restano circa 6,8 GiB per i carichi.
- Aperta l'issue #13 (milestone M1, collegata a #9) con il problema del piazzamento e le due proposte; da decidere insieme e scrivere in D0006.

## Problemi e soluzioni

- Il problema del piazzamento resta aperto: l'etichetta `calcolo` di `worker-2` contraddice la presenza dello standby di V4, e le regole di piazzamento non sono ancora scritte. Proposte scritte nell'issue.

## Limiti dello strumento emersi

- Con due soli worker e dischi locali (`local-path`) legati al nodo, un guasto di macchina non può essere recuperato da un altro nodo per i componenti con stato (database e coda), e le API restano senza posto se la regola di piazzamento è rigida.
