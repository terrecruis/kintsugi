#!/usr/bin/env bash
# Crea label e milestone del progetto sul repository GitHub collegato.
# Uso: dopo aver creato il repository remoto e fatto il primo push,
#   ./scripts/github-setup.sh
# Richiede gh autenticato (gh auth login). Si può rilanciare: salta ciò che esiste già.
set -euo pipefail

repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo "Repository: $repo"

# Label: una per fase della WBS, una per area di lavoro
label() { gh label create "$1" --color "$2" --description "$3" --force >/dev/null && echo "label $1"; }
label "F0-preparazione"   "c5def5" "Repository, strumenti, account AWS"
label "F1-architettura"   "c5def5" "A1-A6, protocollo di misura, previsioni"
label "F2-app"            "c5def5" "Applicazione minima e tre versioni"
label "F3-k8s-locale"     "c5def5" "Kubernetes locale e harness minimo"
label "F4-banco-prova"    "c5def5" "Osservabilità e harness completo"
label "F5-campagna"       "c5def5" "Campagna locale"
label "F6-aws"            "c5def5" "Prova e sessioni AWS"
label "F7-analisi"        "c5def5" "Analisi e confronto con la teoria"
label "F8-report"         "c5def5" "Report, diario e orale"
label "decisione"         "fbca04" "Richiede una voce nel registro delle decisioni"
label "misura"            "0e8a16" "Tocca il protocollo o l'harness di misura"
label "limite-strumento"  "d93f0b" "Limite di uno strumento da riportare nel report"

# Milestone M1-M7 con il criterio di passaggio
existing=$(gh api "repos/$repo/milestones?state=all" -q '.[].title')
milestone() {
  if grep -qxF "$1" <<<"$existing"; then echo "milestone $1 (già presente)"; return; fi
  gh api "repos/$repo/milestones" -f title="$1" -f description="$2" >/dev/null && echo "milestone $1"
}
milestone "M1 - Architettura e previsioni"  "S2. A1-A6, definizioni di misura e previsioni datate. Se non passa: non si inizia F3."
milestone "M2 - App minima"                 "S3. I quattro criteri di F2 soddisfatti. Se non passa: non si tocca Kubernetes."
milestone "M3 - Kubernetes locale"          "S5. V1-V3 su Kubernetes; harness minimo misura un guasto F1 con risoluzione sotto il secondo."
milestone "M3b - Prova AWS"                 "S6. Cluster creato e distrutto, costi e limiti noti. Se non passa: ripianificare subito la fase AWS."
milestone "M4 - Banco di prova"             "S7. I tre criteri di F4 soddisfatti. Se non passa: non parte la campagna F5."
milestone "M5 - Campagna locale"            "S8. Campagna completa con i run validi previsti; decisione sulla fase AWS."
milestone "M6 - Sessioni AWS"               "S10. Sessioni fatte, risorse distrutte, costi annotati."
milestone "M7 - Consegna"                   "S12. Report, diario, repository e orale pronti."
