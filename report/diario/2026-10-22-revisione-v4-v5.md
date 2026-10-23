# 2026-10-22 — Revisione critica del piano, V4 e V5

**Chi:** Francesco · **Fase:** F1 · **Durata:** ? h · **Issue:** —

## Cosa abbiamo fatto

- Aggiunte due architetture: **V4** (V2 con PostgreSQL primario + standby e failover automatico via CloudNativePG, in due modalità di replica: asincrona V4a e sincrona V4s) e **V5** (V3 con worker scalati da KEDA sulla lunghezza della coda).
- Revisione critica dell'intero piano: 18 problemi trovati e corretti, elencati nell'appendice "Revisione critica del piano" del documento.
- Documento di architettura portato alla versione 0.3: nuove decisioni D0005, D0007, D0008, D0014-D0017, tabella unica dei parametri, capitolo sulle minacce alla validità, matrice da 145 a 225 run.
- README e `fasi-e-milestone.md` allineati.

## Perché

- V4 elimina il punto unico di guasto con stato (il database) e misura il compromesso tra durabilità e latenza; V5 porta nel progetto l'elasticità della lezione 12. Ogni versione cambia un solo fattore rispetto a quella da cui deriva.
- I problemi più gravi trovati: `kubectl delete pod` non è un guasto ma una terminazione ordinata; un segnale a PID 1 dall'interno del container viene ignorato dal kernel; con soli crash i parametri delle sonde non contano (RQ3 senza risposta, da cui il nuovo guasto F7 di blocco); `now()` in PostgreSQL restituisce l'inizio della transazione; kind con un solo worker non permette di separare primario e standby.

## Comandi e configurazione

Nessun comando: solo documentazione.

## Risultato

Piano più solido e più ampio: 5 versioni, 7 guasti, 6 domande di ricerca, 225 run, ~306 ore stimate (da 265).

## Problemi e soluzioni

- V4 e V5 estendono la traccia approvata.

## Limiti dello strumento emersi

- kind: con un solo nodo worker non si possono testare anti-affinità e perdita di nodo.
- PostgreSQL: `now()` non è l'istante corrente.
- Kubernetes: il backoff dei riavvii si accumula tra run consecutivi se i pod non vengono ricreati.
