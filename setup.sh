#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

TTYD_PORT="${TTYD_PORT:-7681}"
LOGSTASH_PID_FILE="$ROOT_DIR/.runtime/logstash.pid"
LOGSTASH_LOG_DIR="$ROOT_DIR/.runtime/logs"
LOGSTASH_DATA_DIR="$ROOT_DIR/.runtime/logstash-data"
STARTED_LOGSTASH_PID=""

require_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required to install ttyd and Logstash."
    echo "Install Homebrew first, then rerun ./setup.sh."
    exit 1
  fi
}

install_ttyd() {
  if ! command -v ttyd >/dev/null 2>&1; then
    echo "Installing ttyd..."
    brew install ttyd
  fi
}

install_logstash() {
  if "$ROOT_DIR/bin/logstash" --version >/dev/null 2>&1; then
    return
  fi

  echo "Installing Logstash..."
  if ! brew install logstash; then
    echo "Homebrew logstash formula failed. Trying Elastic tap..."
    brew tap elastic/tap
    brew install elastic/tap/logstash-full
  fi
}

prepare_demo_files() {
  mkdir -p samples results "$LOGSTASH_LOG_DIR" "$LOGSTASH_DATA_DIR"

  if [[ ! -f samples/100k.log ]]; then
    ./scripts/generate_100k.sh
  fi
}

start_logstash_api() {
  if curl -fsS http://127.0.0.1:9600/_node/stats/pipelines >/dev/null 2>&1; then
    echo "Logstash API is already available on http://127.0.0.1:9600"
    return
  fi

  if [[ -f "$LOGSTASH_PID_FILE" ]]; then
    local existing_pid
    existing_pid="$(cat "$LOGSTASH_PID_FILE")"
    if [[ -n "$existing_pid" ]] && kill -0 "$existing_pid" >/dev/null 2>&1; then
      echo "Logstash appears to be starting or running with pid $existing_pid"
      return
    fi
    rm -f "$LOGSTASH_PID_FILE"
  fi

  echo "Starting Logstash API demo process..."
  "$ROOT_DIR/bin/logstash" \
    -f "$ROOT_DIR/pipelines/api-monitor.conf" \
    --path.settings "$ROOT_DIR" \
    --path.data "$LOGSTASH_DATA_DIR" \
    >"$LOGSTASH_LOG_DIR/logstash-api.log" 2>&1 &

  STARTED_LOGSTASH_PID="$!"
  echo "$STARTED_LOGSTASH_PID" > "$LOGSTASH_PID_FILE"

  for _ in {1..60}; do
    if curl -fsS http://127.0.0.1:9600/_node/stats/pipelines >/dev/null 2>&1; then
      echo "Logstash API is ready on http://127.0.0.1:9600"
      return
    fi
    sleep 1
  done

  echo "Logstash did not become ready. See $LOGSTASH_LOG_DIR/logstash-api.log"
  exit 1
}

cleanup() {
  if [[ -n "$STARTED_LOGSTASH_PID" ]] && kill -0 "$STARTED_LOGSTASH_PID" >/dev/null 2>&1; then
    echo "Stopping Logstash API demo process..."
    kill "$STARTED_LOGSTASH_PID" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT

require_homebrew
install_ttyd
install_logstash
prepare_demo_files
start_logstash_api

echo "Starting embedded terminal server on http://127.0.0.1:$TTYD_PORT"
echo "Keep this process running while presenting."
ttyd -i 127.0.0.1 -p "$TTYD_PORT" -W zsh
