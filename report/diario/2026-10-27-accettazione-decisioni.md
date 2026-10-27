# 2026-10-27 — Revisione e accettazione delle decisioni D0001-D0011

**Chi:** Gianmarco e Francesco (insieme, in chiamata) · **Fase:** F1 · **Durata:** 2 h · **Issue:** #8, #9, #14

## Cosa abbiamo fatto

Letto una per una le decisioni ancora aperte e le abbiamo portate tutte ad «accettata»; per ognuna si è discusso se il testo fosse coerente con il resto del documento.

| Decisione | Esito |
|---|---|
| D0001 sincrono o con coda | Accettata: l'API risponde «ok» solo dopo la conferma del posto dove l'ordine è stato messo |
| D0002 configurazione della coda | Accettata, compreso RabbitMQ in una sola istanza (punto unico di guasto voluto, per F3) |
| D0003 riprova dei worker | Accettata; i 120 s sono **indicativi** e si verificheranno sul campo, nella misura dei tempi di riavvio e nei primi test |
| D0004 ordini doppi | Accettata: si salva una riga per ogni doppio, con tutti i dettagli |
| D0005 timestamp | Accettata, con una frase in più: `ts_scrittura` è l'istante dell'inserimento, non del commit; l'attesa della replica sincrona di V4s si legge nella latenza del client |
| D0006 piazzamento dei pod | Scritta e accettata (vedi sotto) |
| D0007 sonde | Accettata; contesto riscritto (la sonda di liveness farebbe riavviare, quella di readiness farebbe uscire dal Service) e **timeout delle sonde fissato a 1 s** |
| D0008 timeout e deadline | Accettata: il «cliente» è JMeter, il suo timeout (2 s) è un'impostazione nostra |
| D0009 AWS | Scritta e accettata: regione `eu-west-1`, `eksctl`, istanze a prestazioni fisse (famiglia `m5`), Kubernetes 1.37 |
| D0010 connessioni al database | Scritta e accettata: 5 connessioni per pod, al massimo 80 in totale |
| D0011 linguaggio | Scritta e accettata: Python (scartati Spring Boot e TypeScript) |

**D0006, piazzamento dei pod** (risolve l'issue #14): database e coda su `kintsugi-worker` con regola rigida; in V4 primario su `kintsugi-worker` e standby su `kintsugi-worker2`, mai sullo stesso nodo; API e worker preferiscono `kintsugi-worker2` e, se cade, possono andare su `kintsugi-worker`; Prometheus e Grafana su `kintsugi-worker`. L'etichetta `calcolo` vuol dire «preferito dai componenti senza stato», e ospita anche lo standby di V4. Il nodo «jolly» (terzo worker) non è previsto ora: si aggiunge solo se avanza tempo, per provare F6 con un nodo di riserva.

Aggiornati di conseguenza: registro delle decisioni, tabella dei parametri (timeout delle sonde 1 s; connessioni al database), cap. 3, 4 e 8, commenti di `kind-cluster.yaml` e piano delle fasi (F6: `eksctl`).

## Perché

Per M1 (04/11/2026) il criterio è «decisioni scritte, parametri fissati, previsioni committate»: senza decisioni chiuse non si possono fissare i valori (#10) né scrivere le previsioni (#11). Il piazzamento in particolare condiziona F6 e la protezione che V4 offre davvero.

## Comandi e configurazione

## Risultato

- Tutte le 17 decisioni (D0001-D0017) sono «accettate».
- Cambiati anche i tempi previsti per accorgersi di un blocco (F7): da circa 3-6 s / 30 s a circa 4-7 s / 31 s, perché il timeout della sonda si somma; la formula del cap. 8 diventa `p × s + t`. Sono ancora stime: si confermano con la misura in F7.
- Da fare per M1: #10 (valori principali), #11 (previsioni e tag `m1`), #6 (account AWS, Francesco).

## Problemi e soluzioni

- Il conto delle connessioni al database era sbagliato: includeva le API di V3 e V5, che pubblicano sulla coda e non si collegano al database. Corretto: nel caso peggiore (V5, 10 worker) sono 10 pod, cioè 50 connessioni con pool da 5.
- Il cluster locale è ARM (Mac M5), le istanze `m5` su AWS sono x86: le immagini vanno costruite per entrambe le architetture e la differenza va dichiarata nel confronto tra ambienti (RQ6). Si può scegliere un tipo ARM (`m6g`) nella prova di S6.
- Il piano gratuito di un nuovo account AWS è limitato a servizi selezionati e non risulta se include EKS: per l'account (#6) scegliere il piano Paid.

## Limiti dello strumento emersi

- Mac ARM (locale) contro istanze x86 su AWS: differenza di architettura tra i due ambienti, da dichiarare. Nessun impatto sulle misure locali.
