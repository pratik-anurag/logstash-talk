mkdir -p samples results
cat > samples/one.log <<'LOG'
2026-05-24T10:15:30Z api-01 INFO user=pratik action=login status=200 latency_ms=34
LOG

for i in $(seq 1 100000); do cat samples/one.log; done > samples/100k.log
