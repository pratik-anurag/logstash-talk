#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

bin/logstash -f pipelines/02-dissect.conf < samples/one.log
