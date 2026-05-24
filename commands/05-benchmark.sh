#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

./scripts/generate_100k.sh
rm -rf /tmp/ls-dissect /tmp/ls-grok /tmp/ls-grok-expensive

/usr/bin/time -p bin/logstash \
  -f pipelines/bench-dissect.conf \
  --path.data /tmp/ls-dissect

/usr/bin/time -p bin/logstash \
  -f pipelines/bench-grok.conf \
  --path.data /tmp/ls-grok

/usr/bin/time -p bin/logstash \
  -f pipelines/bench-grok-expensive.conf \
  --path.data /tmp/ls-grok-expensive
