# Tabella unica dei parametri di salute e timeout

*Parte di A5. Gli stessi valori valgono in locale e su AWS; ogni modifica passa da una decisione nel registro. I manifest leggono questi valori: se cambia qui, cambia anche lì nella stessa PR.*

| Parametro | Componente | Locale | AWS | Decisione |
|---|---|---|---|---|
| Repliche API (V2, V3) | API | TODO | = | 0007 |
| Repliche worker (V3) | Worker | TODO | = | 0007 |
| Liveness: intervallo / soglia di fallimento / timeout | API, worker | TODO | = | 0007 |
| Readiness: ritardo iniziale / intervallo / soglia | API, worker | TODO | = | 0007 |
| Timeout del client | JMeter | TODO | = | 0008 |
| Riprova worker: attesa iniziale / fattore / durata totale | Worker | TODO | = | 0003 |
| Pool di connessioni al DB | API, worker | TODO | = | 0010 |
| `max_connections` PostgreSQL | PostgreSQL | TODO | = | 0010 |
| Tempo di servizio simulato | API, worker | TODO | = | — |
| ALB: intervallo / soglie dei controlli di salute | ALB | — | TODO | 0007 |
| ALB: deregistration delay | ALB | — | TODO | 0007 |
