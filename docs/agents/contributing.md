# Contributing

## Commit Guidelines

- **Atomic and Unitary:** Each commit must represent a single logical change.
  *Example:*
  - Good: `Add minimum option to Mercy::Report::Range`
  - Bad: `Add minimum option to Range and refactor StatusBuilder`
- **No Unrelated Changes:** Do not mix unrelated changes in the same commit.
- **Separate Refactoring:** Whenever possible, separate refactoring commits from new feature or bugfix commits.

## Pull Requests

- **Descriptive Summary:** Every PR must include a clear and descriptive summary of its purpose and changes.
- **PR Description Files:** If a description cannot be provided directly in the PR, generate a file with the PR description (e.g., `docs/agents/issues/<pr_number>_description.md`), but do not commit this file.

## Definition of Done for PRs

A PR is considered complete when:

- The stated objective has been achieved.
- All tests are passing.
- Linting passes without errors.
- Code coverage is as high as reasonably possible.
- Public API is documented with YARD and the yardstick measurement passes.
- Code is not overly complex:
  - Classes and methods should have clear, focused responsibilities.
  - If a class or method is taking on too many responsibilities, refactor to simplify.
  - Methods should be small and do exactly one thing. If a method is growing, extract parts into private helper methods or separate classes.
  - *Example:*

    ```ruby
    # Good: each method does one thing
    class Worker
      def fetch_job; end

      def process_job(job); end
    end

    # Bad: method does too much
    class Worker
      def run
        fetch_job
        process_job
        send_metrics
        cleanup
      end
    end
    ```

  - This requirement applies primarily to source code. For specs, refactor only if there is excessive duplication.

### CI Checks

Before a PR is considered complete, all CI checks relevant to the modified parts of the project must pass locally.

CircleCI (`.circleci/config.yml`) runs a single `build` job for the whole repository:

| Modified folder | CircleCI job | Local commands |
| --- | --- | --- |
| any (`lib/`, `spec/`, `config/`, root files) | `build` | `bundle exec rspec` && `rubocop` && `bundle exec rake verify_measurements` && `scripts/check_readme.sh` |
| `lib/` | `build` (rubycritic step) | `bundle exec rubycritic --format console --branch origin/master -t 0 <changed lib files>` |

Inside Docker, `docker-compose run test_all` runs rspec, yard and the yardstick checks.

`scripts/check_readme.sh` verifies that the README links the YARD documentation for the current version in `lib/mercy/version.rb`; bump both together.

If a new folder or CI job is added in the future, its corresponding test and check commands must be included here before merging changes to that folder.

This same process must be followed when **planning how to resolve an issue**: include a final step in the plan that identifies the affected folders and lists the CI commands to run before opening a PR.

## Code Organization

### File Responsibility: Class Declarers vs Scripts

Every source file under `lib/` must act as a **class declarer** — it should define one or more classes or modules. Files must not act as **scripts** (i.e., they must not execute logic at require time or perform side effects beyond requiring dependencies and defining constants).

This is a library: there are no executable entrypoints. `lib/mercy.rb` is the gem's load entrypoint and only requires dependencies and components. Inside the test suite, `spec/dummy/` is a Rails application whose boot files (`config/`, `bin/`) are exempt.

*Example:*

```ruby
# Good: class declarer — defines a class
module Mercy
  class PeriodParser
    def to_seconds; end
  end
end

# Bad: script — executes logic at require time
builder = Mercy::StatusBuilder.new
builder.add_report_config(:failures, clazz: Document)
```

Test files are exempt from this rule and may require modules and execute setup code freely.

### File Naming: snake_case Matching the Constant

Files must use **snake_case** naming matching the class/module they define, with the directory path mirroring the namespace.

*Examples:*

- `lib/mercy/status_builder.rb` for `Mercy::StatusBuilder`
- `lib/mercy/report_config.rb` for `Mercy::ReportConfig`
- `lib/mercy/report/range.rb` for `Mercy::Report::Range`

This applies to both source files and their corresponding spec files:

- `lib/mercy/status_builder.rb` → spec: `spec/lib/mercy/status_builder_spec.rb`
- `lib/mercy/report/range.rb` → spec: `spec/lib/mercy/report/range_spec.rb`

Every Ruby file starts with `# frozen_string_literal: true`.

### Method Order: Public Before Private

Within a class, **public methods must be declared before private methods**. Private methods serve as implementation helpers and should appear at the end of the class body, after a single `private` keyword.

*Example:*

```ruby
# Good: public methods first, private methods last
class Worker
  def run
    prepare
    execute
  end

  def status; end

  private

  def prepare; end

  def execute; end
end

# Bad: private methods mixed in with or before public methods
class Worker
  private def prepare; end

  def run; end

  private

  def execute; end
end
```

## Dependency Injection

Classes must receive their dependencies (data, configuration, collaborators) as constructor arguments. A class must never reach out to load files, read environment variables, or fetch configuration on its own.

**The caller is the only place responsible for loading configuration.** In Mercy, configuration comes from the host controller (`status_report` options) and request params, and is passed down through `StatusBuilder` → `ReportBuilder` → `ReportConfig` → report instances.

This makes every class independently testable: tests simply instantiate the class with the data they need, without touching the filesystem or environment.

*Example:*

```ruby
# Good: class receives data as an argument — easy to test
class Mercy::ReportConfig
  def initialize(config)
    @config = config
  end
end

# Bad: class loads its own config — hard to test and couples to the filesystem
class Mercy::ReportConfig
  def config
    YAML.load_file('config/mercy.yml') # ❌
  end
end
```

This principle applies to all classes — including helpers and builders. If a class needs data, it gets it through its constructor.

## Refactoring Guidelines

When refactoring, aim to:

- **Reduce Code Duplication:**
  *Example:* Move repeated setup code in specs to `let`, shared contexts or helpers under `spec/support/`.

  ```ruby
  # Good
  shared_context 'with documents' do
    let(:documents) { create_documents(status: :error, count: 3) }
  end
  # In specs:
  include_context 'with documents'

  # Bad
  let(:documents) { 3.times.map { Document.create(status: :error) } }
  # ...repeated in many spec files
  ```
