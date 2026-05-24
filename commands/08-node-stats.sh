#!/usr/bin/env bash
set -euo pipefail

curl -s localhost:9600/_node/stats/pipelines?pretty
