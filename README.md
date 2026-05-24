# Logstash Is Not Free Compute - Reveal.js Talk

A 30-minute interactive reveal.js deck on Logstash performance gotchas, focused on demos and gradual complexity.

## Run the slides

Setup installs the local demo tools, prepares benchmark data, starts a Logstash API process on port `9600`, and starts the embedded terminal on port `7681`:

```bash
./setup.sh
```

Option 1: open `index.html` directly in a browser.

Option 2: serve locally:

```bash
python3 -m http.server 8000
# open http://localhost:8000
```

The deck uses reveal.js from a CDN, so internet access is required when presenting.

## Optional embedded terminal

Demo slides include a `>_` button that opens an iframe terminal. Start the setup script before presenting:

```bash
./setup.sh
```

The setup script runs these setup steps:

```bash
brew install ttyd
brew install logstash
ttyd -i 127.0.0.1 -p 7681 -W zsh
```

If the Homebrew `logstash` formula is unavailable, the script falls back to `elastic/tap/logstash-full`.

By default, the deck opens `http://localhost:7681`. To use a different terminal URL:

```bash
http://localhost:8000?terminal=http://localhost:9000
```

Only run the terminal server on a trusted machine and keep it bound to localhost.

## Demo command files

Every runnable slide command has a matching file under `commands/`, so you can copy-paste a single command in the embedded terminal:

```bash
./commands/01-hello.sh
./commands/02-dissect.sh
./commands/03-grok.sh
./commands/04-generate-100k.sh
./commands/05-benchmark.sh
./commands/06-failure-tags.sh
./commands/07-type-bug.sh
./commands/08-node-stats.sh
./commands/09-final-debugging.sh
```

Exact non-runnable slide snippets are stored under `snippets/`.

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
