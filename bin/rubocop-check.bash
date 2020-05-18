#!/usr/bin/env bash

set -e

cd "${0%/*}/.."

echo "Corriendo rubocop"
bundle exec rubocop