# Logstash Is Not Free Compute - Reveal.js Talk

A 30-minute interactive reveal.js deck on Logstash performance gotchas, focused on demos and gradual complexity.

## Run the slides

Option 1: open `index.html` directly in a browser.

Option 2: serve locally:

```bash
python3 -m http.server 8000
# open http://localhost:8000
```

The deck uses reveal.js from a CDN, so internet access is required when presenting.

## Speaker controls

- Space / arrows: navigate
- `S`: speaker notes
- `Esc`: overview
- `B`: blank screen

## Demo flow

1. `pipelines/01-hello.conf`
2. `pipelines/02-dissect.conf`
3. `pipelines/03-grok.conf`
4. `pipelines/04-failure-tags.conf`
5. `scripts/generate_100k.sh`
6. `pipelines/bench-dissect.conf`
7. `pipelines/bench-grok.conf`
8. `pipelines/bench-grok-expensive.conf`

## Benchmark notes

Use different `--path.data` values per run. Avoid `rubydebug` in benchmarks because console output dominates parser cost.
