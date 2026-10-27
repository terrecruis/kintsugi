# 2026-10-27 — Revisione del documento di architettura (v0.8)

**Chi:** Francesco · **Fase:** F1 · **Durata:** 3 h · **Issue:** #17

## Cosa abbiamo fatto

- Analizzato l'intero repository (documento, README, piano delle fasi, diario, issue) e confrontato il documento con la traccia originale.
- Portato il documento alla versione 0.8 con un registro più formale, mantenendo una spiegazione breve accanto a ogni termine tecnico.
- Reintegrate dalla traccia le parti perse con la semplificazione della v0.5:
  - definizioni (disponibilità di accettazione e di completamento, ripristino, fermo, tempo end-to-end);
  - categorie degli ordini e controllo di coerenza;
  - struttura del run, carichi W1-W3, validità e statistica.
- Limiti degli esperimenti classificati per tipo di minaccia (interna, di costrutto, esterna, delle conclusioni).
- Nuovi diagrammi:
  - metodo;
  - ambiente locale ridisegnato sui nodi reali;
  - ambiente AWS;
  - anatomia di un fermo (crash contro blocco);
  - albero delle categorie e linea del tempo di un run;
  - matrice degli esperimenti;
  - Gantt con le ore per fase.
- Corretti:
  - D0005: spiegato perché i due istanti usano lo stesso orologio;
  - punti unici di guasto di V4s;
  - Toxiproxy aggiunto in V1 e V4;
  - rimando inesistente «§ 5.3» in `data/README.md`.
- Aggiunte al `.gitignore` le configurazioni locali degli assistenti AI.

## Perché

Il documento è ciò che viene valutato. Le definizioni di misura servono già a M1 (previsioni) e a F2 (lo script che assegna le categorie): senza di esse le previsioni non sarebbero confrontabili con le misure.

## Risultato

- PDF di 42 pagine, compilato senza errori né riferimenti mancanti.
- Restano in rosso, da chiudere con #10 e #11:
  - le 17 configurazioni senza guasti (85 run);
  - i livelli dei carichi W1-W3;
  - la tabella delle previsioni.

## Problemi e soluzioni

- Un riempimento tratteggiato (libreria TikZ `patterns`) produceva un PDF che compila ma risulta corrotto per i lettori basati su Poppler (migliaia di «Syntax Error»). Sostituito con un riempimento semplice; il PDF torna integro.

## Limiti dello strumento emersi

- TikZ `patterns` con pdfTeX: PDF illeggibile da Poppler (`pdfinfo`, `pdftoppm`). Da evitare nelle figure.
