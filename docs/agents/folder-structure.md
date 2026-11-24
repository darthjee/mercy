# Folder Structure

## Project Root

| Directory / File | Description |
|-----------------|-------------|
| `lib/` | Gem source code (`Mercy` module, reports, builders, Arstotzka type-cast extension). |
| `spec/` | RSpec test suite: unit specs, integration specs, a dummy Rails app and shared support code. |
| `config/` | Configuration for code-quality tooling (yardstick thresholds, rubycritic task). |
| `scripts/` | CI helper scripts (README version check, rubycritic run). |
| `docs/agents/` | Agent-facing documentation: architecture, flow, issues and plans. |
| `.circleci/` | CircleCI pipeline configuration. |
| `.github/` | PR/commit message templates and Copilot instructions. |
| `mercy.gemspec` | Gem specification: version, runtime and development dependencies. |
| `Rakefile` | Rake tasks (`spec`, yardstick measurement/verification). |
| `Dockerfile` / `docker-compose.yml` | Containerized dev/test environment (`mercy` runs rspec, `test_all` runs rspec + yard + yardstick). |
| `.rubocop.yml` / `.rubocop_todo.yml` | RuboCop configuration and pending offenses. |

## spec/

| Subdirectory | Description |
|--------------|-------------|
| `lib/` | Unit specs mirroring `lib/` (`mercy/`, `arstotzka/`). |
| `integration/` | Integration specs: `controller/` (concern inside the dummy Rails app) and `yard/` (examples from YARD docs). |
| `dummy/` | Minimal Rails application used to exercise the controller concern. |
| `support/` | Shared contexts/examples, test models and fixture helpers. |
