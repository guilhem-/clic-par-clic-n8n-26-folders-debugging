#!/usr/bin/env bash
# Sends an expense report to the "Expense report intake" workflow, like the expense app in the video.
#   ./send-report.sh             complete report (amount included): successful execution
#   ./send-report.sh --no-amount report without an amount: failed execution, to replay with "Debug in editor"
# Settings are read from .env (copy .env.example): N8N_URL and N8N_WEBHOOK_PATH.
set -euo pipefail
cd "$(dirname "$0")"
if [ -f .env ]; then set -a; . ./.env; set +a; fi
N8N_URL="${N8N_URL:-http://localhost:5678}"
N8N_WEBHOOK_PATH="${N8N_WEBHOOK_PATH:-expense-reports}"

case "${1:-}" in
  "") BODY='{"user":"Camille Martin","category":"Transport","amount":42.5}' ;;
  --no-amount) BODY='{"user":"Camille Martin","category":"Transport"}' ;;
  *) echo "unknown option: $1 (expected: --no-amount)" >&2; exit 2 ;;
esac

curl -s -X POST "${N8N_URL%/}/webhook/${N8N_WEBHOOK_PATH}" \
  -H "Content-Type: application/json" \
  -d "$BODY"
echo
