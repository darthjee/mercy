#!/usr/bin/env bash
set -euo pipefail
set -x

docker-compose run --rm mercy /bin/bash -c 'bundle exec rspec'
docker-compose run --rm mercy /bin/bash -c 'rubocop'
docker-compose run --rm mercy /bin/bash -c 'yard && bundle exec rake yardstick_measure && bundle exec rake verify_measurements'
