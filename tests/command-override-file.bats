#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'
load '../lib/shared'

command_override_file=$(cat <<-BASH
#!/bin/bash
set -ueo pipefail

echo "~~~ Saving caches"
printf "  %s\n" tmp/cache/assets/*
printf "  %s\n" public/assets/*
BASH
)

@test "Build an command override file" {
  export BUILDKITE_PLUGIN_CACHE_SAVE_0=tmp/cache/assets/*
  export BUILDKITE_PLUGIN_CACHE_SAVE_1=public/assets/*

  run build_command_override_file

  assert_success
  assert_output "$command_override_file"
}
