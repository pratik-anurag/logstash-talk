#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

bin/logstash -f pipelines/05-type-bug.conf < samples/status-200.log
