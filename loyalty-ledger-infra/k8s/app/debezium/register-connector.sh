#!/bin/sh
# Registers (or updates) the outbox connector and waits for the task to reach RUNNING.
# Until the application runs the migrations, the dbz_outbox publication does not exist and the
# task fails, so it is restarted until they happen. Used by compose and by the k8s Job.
set -eu

: "${CONNECT_URL:?set CONNECT_URL}"
NAME=ledger-outbox

until curl -fsS -o /dev/null "$CONNECT_URL/connectors"; do
  echo "waiting for Kafka Connect at $CONNECT_URL"
  sleep 5
done

curl -fsS -o /dev/null -X PUT -H "Content-Type: application/json" \
  --data @/config/outbox-connector.json "$CONNECT_URL/connectors/$NAME/config"

while true; do
  status=$(curl -fsS "$CONNECT_URL/connectors/$NAME/status" || true)
  case "$status" in
    *'"tasks":[{"id":0,"state":"RUNNING"'*)
      echo "connector $NAME RUNNING"
      exit 0
      ;;
    *FAILED*)
      echo "task failed (migrations not applied yet?); restarting in 10s"
      curl -fsS -o /dev/null -X POST "$CONNECT_URL/connectors/$NAME/restart?includeTasks=true&onlyFailed=true" || true
      ;;
  esac
  sleep 10
done
