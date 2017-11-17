#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'
load '../lib/shared'

@test "Download a single directory" {
  export BUILDKITE_PLUGIN_CACHE_DIRECTORIES=tmp/caches/assets/*

  stub buildkite-agent \
    "artifact download tmp/caches/assets/* . : echo downloaded tmp/caches/assets/*"

  run $PWD/hooks/post-checkout

  assert_success
  assert_output --partial "downloaded tmp/caches/assets/*"
  unstub buildkite-agent
}

@test "Download several directories" {
  export BUILDKITE_PLUGIN_CACHE_DIRECTORIES_0=tmp/caches/assets/*
  export BUILDKITE_PLUGIN_CACHE_DIRECTORIES_1=public/assets/*

  stub buildkite-agent \
    "artifact download tmp/caches/assets/* . : echo downloaded tmp/caches/assets/*" \
    "artifact download public/assets/* . : echo downloaded public/assets/*"

  run $PWD/hooks/post-checkout

  assert_success
  assert_output --partial "downloaded tmp/caches/assets/*"
  assert_output --partial "downloaded public/assets/*"
  unstub buildkite-agent
}
