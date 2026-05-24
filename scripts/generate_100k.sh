#!/usr/bin/env bash
set -euo pipefail
mkdir -p samples results
for i in $(seq 1 100000); do cat samples/one.log; done > samples/100k.log
wc -l samples/100k.log
