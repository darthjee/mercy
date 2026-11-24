#!/usr/bin/env bash
set -euo pipefail
set -x

docker-compose build base_build
docker-compose run --rm test_all
