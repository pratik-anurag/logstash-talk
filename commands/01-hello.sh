#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

printf 'user=pratik action=login status=200\n' | bin/logstash -f pipelines/01-hello.conf
