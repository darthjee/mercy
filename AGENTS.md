# Project Instructions

Mercy is a Ruby gem for easy server health checks: a Rails controller concern
(`include Mercy`, `status_report`, `render_status`) that builds configurable
reports (`Error`, `Range`, `Multiple`) over ActiveRecord scopes and renders them
as a JSON status.

## Stack

- Ruby (>= 2.5)
- ActiveSupport 5 / Rails controller concern, ActiveRecord
- arstotzka, darthjee-core_ext, darthjee-active_ext
- RSpec, RuboCop, YARD (yardstick), SimpleCov
- Docker (docker-compose) and CircleCI

## Conventions

- Tests are written with RSpec (unit and integration specs under `spec/`).
- RuboCop must pass.
- Public API is documented with YARD (checked with yardstick).
- Every Ruby file starts with `# frozen_string_literal: true`.

## Documentation

All project documentation lives under [`docs/agents/`](docs/agents/):

| File | Contents |
|------|----------|
| [Folder Structure](docs/agents/folder-structure.md) | Top-level directory layout and the role of each folder. |
| [Architecture](docs/agents/architecture.md) | Source layout, modules, code style, and implementation guidelines. |
| [Flow](docs/agents/flow.md) | Main runtime flow of the application. |
| [Contributing](docs/agents/contributing.md) | Commit guidelines, PR standards, code organization, and refactoring rules. |
| [Plans](docs/agents/plans/) | Implementation plans for ongoing or upcoming features. |
| [Issues](docs/agents/issues/) | Detailed specs for open issues. |

### Issues (`docs/agents/issues/`)

Each file documents an issue in detail. Naming convention:

```
docs/agents/issues/<issue_id>_<issue_name>.md
```

Example: `docs/agents/issues/5_release_docker_image.md` for issue #5.

### Plans (`docs/agents/plans/`)

Each plan is a directory named after the issue ID and topic, containing one or more related files:

```
docs/agents/plans/<issue_id>_<topic>/<related_files>.md
```

Example: `docs/agents/plans/12_add-auth/plan.md` for issue #12.

## Commit Attribution

Commit co-author trailers follow arcanum's resolved `git.omit_model_coauthor` and `git.remove_coauthors` config (check them with `/arcanum-check-config`); this overrides Claude Code's own attribution reminder for every commit, including ones written by hand.
