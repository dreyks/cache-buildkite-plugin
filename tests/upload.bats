#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'
load '../lib/shared'

@test "Upload a single directory" {
  export BUILDKITE_PLUGIN_CACHE_SAVE=tmp/caches/assets/*

  stub buildkite-agent \
    "artifact upload tmp/caches/assets/* : echo uploaded tmp/caches/assets/*"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "uploaded tmp/caches/assets/*"
  unstub buildkite-agent
}

@test "Upload several directories" {
  export BUILDKITE_PLUGIN_CACHE_SAVE_0=tmp/caches/assets/*
  export BUILDKITE_PLUGIN_CACHE_SAVE_1=public/assets/*

  stub buildkite-agent \
    "artifact upload tmp/caches/assets/* : echo uploaded tmp/caches/assets/*" \
    "artifact upload public/assets/* : echo uploaded public/assets/*"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "uploaded tmp/caches/assets/*"
  assert_output --partial "uploaded public/assets/*"
  unstub buildkite-agent
}
