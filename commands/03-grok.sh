#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

bin/logstash -f pipelines/03-grok.conf < samples/one.log
