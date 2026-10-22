# 2026-10-22 — Documentazione spostata in un progetto LaTeX

**Chi:** Francesco · **Fase:** F0/F1 · **Durata:** ? h · **Issue:** —

## Cosa abbiamo fatto

Sostituiti i file Markdown sparsi che c'erano in `docs/` (A1-A6, parametri, registro delle decisioni) con un progetto LaTeX che compila in un unico PDF: architettura, diagrammi (con TikZ) e decisioni ora vivono lì, a un livello di dettaglio essenziale. Le decisioni restano un file per voce, sotto `sections/decisioni/`, incluso da `05-decisioni.tex`, così si continua ad aggiungerne una per pull request.

Scambiati anche i nomi delle due cartelle di primo livello: **`docs/` è ora il progetto LaTeX** (architettura, diagrammi di progetto, decisioni), **`report/` è il materiale che cresce in continuo**: diario (una voce a sessione e un breve riassunto schematico a ogni commit rilevante), `fasi-e-milestone.md` (pianificazione) e `diagrammi/` (grafici generati dall'analisi dei run, a valle dei test — non i diagrammi di architettura, quelli sono in TikZ dentro `docs/`).

## Perché

I file A1-A6 separati avevano un livello di dettaglio troppo alto per questa fase del progetto (template completi per ogni possibile campo, anche dove non c'era ancora nulla da scrivere). Un documento unico, essenziale, con i `[DA COMPLETARE]` espliciti è più facile da tenere aggiornato e corrisponde meglio a come il progetto chiede di presentare l'architettura: un report, non una cartella di appunti.

## Comandi e configurazione

```bash
git rm docs/A1-requisiti-e-misure.md docs/A2-componenti.md docs/A3-deployment.md \
       docs/A4-modello-guasti.md docs/A6-previsioni.md docs/parametri.md
git rm -r docs/decisioni

mkdir _swap_tmp
git mv docs/diario _swap_tmp/diario
git mv docs/fasi-e-milestone.md _swap_tmp/fasi-e-milestone.md
git mv docs/diagrammi _swap_tmp/diagrammi
rmdir docs
mv report docs
mv _swap_tmp report
```

## Risultato

## Problemi e soluzioni

## Limiti dello strumento emersi
