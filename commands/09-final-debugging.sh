#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

bin/logstash -f pipelines/06-final-debugging.conf < samples/payload.log
