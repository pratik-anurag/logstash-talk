/usr/bin/time -p bin/logstash \
  -f pipelines/bench-dissect.conf \
  --path.data /tmp/ls-dissect

/usr/bin/time -p bin/logstash \
  -f pipelines/bench-grok.conf \
  --path.data /tmp/ls-grok
