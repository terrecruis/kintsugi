# A1 — Requisiti e definizioni di misura

*Stato: bozza. Da completare in F1 (milestone M1). I valori `TODO` si fissano qui una volta sola e valgono per tutte le versioni e tutti gli ambienti.*

## Domande di ricerca

| | Domanda |
|---|---|
| **RQ1** | Quanto downtime e quante richieste fallite produce ogni guasto passando da 1 a N repliche? Quanto si discostano dalle previsioni? Che disponibilità ne risulta con un MTBF ipotizzato? |
| **RQ2** | Sincrono contro asincrono, a parità di carico e timeout: tempo end-to-end, disponibilità di completamento, ordini persi o duplicati, recupero sotto picchi e guasti |
| **RQ3** | Quanto ci mette il servizio a tornare effettivamente operativo, e quanto dipende dai controlli di salute e dal tipo di componente (con o senza stato)? |
| **RQ4** | Con parametri allineati, i risultati locali si ripetono su AWS? |
| *RQ5* | *(opz.) Un autoscaling sulla lunghezza della coda assorbe meglio un picco?* |

## Parametri comuni

| Parametro | Valore | Note |
|---|---|---|
| Timeout comune del client | TODO (es. 2 s) | Identico per V1, V2, V3 |
| Limite di completamento | TODO (es. 2 s) | Entro quanto un ordine ricevuto deve essere salvato |
| Soglia di secondo disponibile | 99% | Riportare sempre anche le richieste fallite per guasto |
| Finestra di ripristino | 5 s consecutivi | |
| Ritmo W1 / W2 / W3 | TODO | Fissati rispetto alla capacità misurata in F4 |

## Definizioni

- **Richiesta riuscita:** risposta corretta entro il timeout comune del client.
- **Disponibilità di accettazione:** frazione di secondi in cui almeno il 99% delle richieste riesce, vista dal client.
- **Disponibilità di completamento:** frazione di secondi in cui almeno il 99% degli ordini *ricevuti* in quel secondo è salvato nel database entro il limite di completamento. Per V3 è la misura che conta.
- **Ripristinato:** primo istante da cui seguono 5 secondi consecutivi disponibili sia in accettazione sia in completamento. Non coincide con il riavvio del pod.
- **Downtime per guasto:** tempo tra l'istante del guasto e il ripristino, riportato separatamente per accettazione e completamento.
- **Tempo end-to-end:** istante di commit nel database meno istante di ricezione nell'API. Entrambi da orologi del cluster. Metrica comune alle tre versioni.
- **Latenza client:** metrica separata; in V3 misura solo l'accettazione.

## Categorie degli ordini (per ID, per ogni run)

| Categoria | Client | Database |
|---|---|---|
| Completati in tempo | esito positivo | salvato |
| Completati dopo il timeout | errore o timeout | salvato |
| Falliti | errore o timeout | non salvato (fallimento dichiarato) |
| In dead-letter | accettato | finito in dead-letter, rielaborato a fine run |
| **Persi** | **esito positivo** | **mai salvato** (caso grave) |
| Duplicati | — | secondo inserimento rifiutato dal vincolo di unicità (contati a parte) |

**Controllo di coerenza:** ogni ID inviato cade in esattamente una delle prime cinque categorie.

## Validità di un run

- Reset completato (coda vuota, tabella ordini vuota, pod pronti, nessun arretrato).
- Ritmo realmente inviato entro ±5% di quello previsto.
- CPU dell'host sotto la soglia fissata in F4: TODO.
- Nessuno swap dell'host durante il run (decisione 0013).
- Run eseguito sulla macchina della campagna, con la configurazione di Docker dichiarata (decisione 0013).
