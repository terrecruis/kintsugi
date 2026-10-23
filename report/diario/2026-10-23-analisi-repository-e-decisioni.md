# 2026-10-23 — Analisi del repository, modifiche al documento e decisioni confermate

**Chi:** Gianmarco · **Fase:** F1 · **Durata:** 2 h · **Issue:** —

## Cosa abbiamo fatto

- Letto l'intero repository e il documento di architettura (v0.5, poi v0.6) per allinearmi al progetto.
- Aggiunto al documento (ora v0.7):
  - il limite del **control plane unico** (capitolo "I limiti degli esperimenti" e "Cosa non facciamo");
  - i valori delle **sonde standard di Kubernetes** per F7 (ogni 10 s, guasto dopo 3 controlli falliti) e i tempi previsti per accorgersi di un blocco (circa 3-6 s contro circa 30 s);
  - **V3 con 1 e con 10 worker fissi** come riferimenti per V5, il costo misurato in **worker-secondi** e i parametri di KEDA da fissare;
  - esperimenti da 225 a 245 (+20 run), aggiornati README, piano delle fasi e documento.
- Confermate tre decisioni: **D0013** (misure ufficiali solo sul MacBook M5 da 16 GB di Gianmarco; ripiego sul PC da 64 GB, da usare per l'intera campagna), **D0016** (iniezione dei guasti) e **D0017** (SLO al 99,9% e budget di errore).
- Compilato il PDF del documento per verificare le modifiche.

## Perché

- Per comprendere lo stato dell`arte progetto prima di contribuire alle decisioni ancora aperte.
- Il confronto tra V5 e V3 cambiava due fattori insieme (numero di worker di partenza e autoscaling): i due riferimenti permettono di attribuire la differenza.
- La configurazione "standard" delle sonde mancava nella tabella dei parametri, quindi F7 non sarebbe stato riproducibile.
- Le misure su una sola macchina (D0013) rendono confrontabili tutti i risultati.

## Comandi e configurazione

## Risultato

- Decisioni accettate: D0012, D0013, D0014, D0015, D0016, D0017. Restano D0001-D0005, D0007, D0008 in proposta e D0006, D0009, D0010, D0011 da scrivere.
- Modifiche sul branch `docs/limiti-sonde-riferimenti-v3`

## Problemi e soluzioni

- Il valore "3 controlli falliti di fila" per la configurazione veloce delle sonde non era stato fissato prima: scritto per rendere le due configurazioni confrontabili, da confermare. I valori standard sono i predefiniti di Kubernetes, da verificare sulla 1.37.
- Il numero di 85 run senza guasti non ha un calcolo nel documento: da chiarire.

## Limiti dello strumento emersi

