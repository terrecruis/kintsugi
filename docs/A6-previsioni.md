# A6 — Previsioni quantitative

*Regola: queste previsioni si scrivono e si committano **prima** di qualsiasi misura della campagna. Una volta committate non si modificano: eventuali correzioni si aggiungono in fondo, datate e motivate.*

**Data di congelamento:** TODO (commit e tag `m1`)

## Metodo

Downtime ≈ **rilevamento** (intervallo del controllo di salute × soglia di fallimento)
+ **riavvio** (avvio del container, misurato a vuoto in F3)
+ **prontezza** (ritardo iniziale + prima risposta positiva della readiness)
+ per V3 **svuotamento dell'arretrato** (ordini accumulati ÷ capacità in eccesso dei worker).

- Disponibilità di un componente: `A = MTBF / (MTBF + MTTR)`. L'MTBF è un'**ipotesi dichiarata**: TODO (es. 1 guasto al giorno per componente).
- Componenti in serie: `A_tot = A_1 × A_2 × … × A_n`.
- Componenti in parallelo: `A = 1 − (1 − A_1) × (1 − A_2) × …`
- Risultato espresso anche in "nove".

## Previsioni per guasto

| Guasto | Versione | Formula con i valori usati | Downtime previsto | Richieste fallite previste |
|---|---|---|---|---|
| F1 | V1 | | | |
| F1 | V2 | | | |
| F1 | V3 | | | |
| F2 | V3 | | | |
| F3 | V3 | | | |
| F4 | V1 | | | |
| F4 | V2 | | | |
| F4 | V3 | | | |

## Disponibilità proiettata

| Versione | MTBF ipotizzato | MTTR previsto | A | Nove |
|---|---|---|---|---|

## Correzioni successive
