# Documento di architettura

Progetto LaTeX che compila in un unico PDF (`main.pdf`): architettura, diagrammi, decisioni e protocollo di misura di Kintsugi, impostato come documentazione software. Le parti `[DA COMPLETARE]` si riempiono seguendo le milestone in `../report/fasi-e-milestone.md`.

## Struttura

```
docs/
  main.tex                 documento principale: include tutto il resto
  Makefile                 make = compila, make clean = pulisce
  config/
    preambolo.tex          pacchetti
    metadati.tex           titolo, versione, autori, corso: si cambiano solo qui
    stile.tex              colori, intestazioni, titoli, ambiente "decisione"
  frontmatter/
    frontespizio.tex       frontespizio Federico II
    scheda-documento.tex   scheda, storico delle revisioni, convenzioni
    acronimi.tex           acronimi e termini
  chapters/
    01-introduzione.tex … 09-validita.tex
    decisioni/             un ADR per file (D0005-..., D0007-..., ...)
  appendices/
    a-pianificazione.tex   milestone, stima dello sforzo, piano di taglio
    b-revisione.tex        revisione critica del piano: problemi e correzioni
  figures/                 immagini esterne (logo del frontespizio)
```

## Compilare

```bash
make
```

oppure `latexmk -pdf main.tex`. Il PDF e i file intermedi non sono versionati.

## Operazioni frequenti

- **Nuova versione del documento:** aggiorna `\versionedoc` in `config/metadati.tex` e aggiungi una riga allo storico in `frontmatter/scheda-documento.tex`.
- **Nuova decisione:** crea `chapters/decisioni/Dnnnn-titolo.tex` copiando un ADR esistente (ambiente `decisione`), aggiungi `\input` in `chapters/06-decisioni.tex` e aggiorna lo stato nella tabella del registro.
- **Logo:** metti `logo-unina.pdf` (o `.png`) in `figures/`; il frontespizio lo usa da solo.
