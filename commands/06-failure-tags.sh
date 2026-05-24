#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

bin/logstash -f pipelines/04-failure-tags.conf < samples/mixed.log
