# Architecture

## Overview

Mercy is a Rails controller concern for health checks. A controller does
`include Mercy`, declares reports at class level with `status_report`, and
renders them in an action with `render_status(bucket)`.

Declared reports are stored as configurations grouped into **buckets** (`on:`,
default `:default`). On each request the bucket's configurations are turned into
report instances (merging whitelisted request params such as `period` and
`threshold`), aggregated into a `Status`, and rendered as JSON with HTTP status
`:ok` or `:error`.

Report options are read through [Arstotzka](https://github.com/darthjee/arstotzka)
`expose`, with custom type casts (`period`, `infinity_float`).

## Source Code Layout

All source code lives under `lib/`.

### `lib/mercy.rb`

Entry point: requires dependencies (`darthjee-core_ext`, `darthjee-active_ext`,
`arstotzka`) and all Mercy components.

### `lib/mercy/`

- `concern.rb` — `Mercy` as an `ActiveSupport::Concern`; defines the instance
  method `render_status`.
- `class_methods.rb` — `status_report` DSL and the per-controller `status_builder`.
- `status_builder.rb` — groups report keys into buckets and builds a `Status`
  for a bucket.
- `report_builder.rb` — stores a `ReportConfig` per report key and builds reports.
- `report_config.rb` — resolves the report class from `type:` (symbol or class,
  default `:error`) and slices request params to the class's `ALLOWED_PARAMETERS`.
- `status.rb` — aggregates reports; status is `:error` if any report errors.
- `report.rb` — base `Report` class (default options, `status`, `as_json`).
- `period_parser.rb` — parses strings like `3.days` / `1hours` into seconds.
- `version.rb` — gem version.

### `lib/mercy/report/`

- `active_record.rb` — base for ActiveRecord-backed reports: `clazz`,
  `base_scope`, `period`, and chained scope resolution (`'active.with_error'`).
- `error.rb` — `Report::Error`: percentage of records in `scope` within the
  period vs. `threshold`; outputs offending ids.
- `range.rb` — `Report::Range`: count of records in `scope` must be within
  `minimum..maximum`.
- `multiple.rb` — `Report::Multiple` mixin: builds and aggregates sub-reports.

### `lib/arstotzka/`

- `type_cast_ext.rb` — adds `to_period` and `to_infinity_float` casts to
  `Arstotzka::TypeCast`.

## Adding a new report type

Subclass `Mercy::Report` (or `Report::ActiveRecord`), define
`ALLOWED_PARAMETERS`, `DEFAULT_OPTION`, `error?` and `as_json`. It can then be
used via `type: :your_type` (resolved under `Mercy::Report`) or `type: YourClass`.
