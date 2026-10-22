# 2026-10-22 — Creazione del cluster kind a 3 nodi

**Chi:** Francesco · **Fase:** F0 · **Durata:** ~0,5 h · **Issue:** —

## Cosa abbiamo fatto

Creato il cluster locale dell'ambiente A da `deploy/k8s/kind-cluster.yaml`: un control plane e due worker, con etichette `kintsugi/ruolo=dati` (worker-1) e `kintsugi/ruolo=calcolo` (worker-2), e le porte `localhost:8080` (API) e `localhost:3000` (Grafana) esposte solo su 127.0.0.1. Aggiornato `kubectl` alla versione del cluster.

## Perché

Tre nodi servono a separare primario e standby di V4 e a simulare la perdita di un nodo (F6) senza toccare il nodo dei dati. Le porte stanno sul control plane, che nessun esperimento guasta. Con la creazione del cluster F0 è chiusa sul fronte locale.

## Comandi e configurazione

```bash
docker info --format 'Docker {{.ServerVersion}}, memoria {{.MemTotal}} byte, CPU {{.NCPU}}'
kind create cluster --name kintsugi --config deploy/k8s/kind-cluster.yaml
kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl get nodes -L kintsugi/ruolo -o wide
kubectl get pods -n kube-system -o wide
docker stats --no-stream
brew install kubectl
```

## Risultato

| Voce | Valore |
|---|---|
| Docker Desktop | 28.0.4, 4,8 GiB di memoria, 5 CPU |
| kind | v0.33.0 |
| Immagine dei nodi | `kindest/node:v1.37.0` (Debian 13, containerd 2.3.4) |
| Tempo di creazione | 56 s, più ~10 s perché i nodi diventino `Ready` |
| Memoria a cluster vuoto | control plane ~604 MiB, worker ~132 MiB ciascuno: ~870 MiB in tutto |
| Memoria libera per i carichi | ~3,9 GiB |

Componenti di sistema verificati: API server, etcd, scheduler, controller manager e CoreDNS sul control plane; kube-proxy e kindnet su ogni nodo.

## Problemi e soluzioni

- Subito dopo la creazione i nodi risultano `NotReady` per alcuni secondi, finché la rete dei Pod (kindnet) non è pronta: si attende con `kubectl wait`.
- `kubectl` installato da Docker Desktop era la v1.32, il cluster la v1.37: Kubernetes garantisce la compatibilità solo entro una versione di differenza. Installato `kubectl` v1.37.1 con Homebrew, che nel PATH precede quello di Docker Desktop.

## Limiti dello strumento emersi

- kind sceglie un'immagine dei nodi diversa a ogni sua versione: senza fissarla nel file, due macchine con versioni di kind diverse avrebbero cluster diversi. Fissata a `kindest/node:v1.37.0`.
- Il control plane da solo occupa ~600 MiB: su un Mac da 8 GB è la voce di memoria più pesante del cluster vuoto.
