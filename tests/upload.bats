#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'
load '../lib/shared'

@test "Does nothing if nothing passed to save" {
  run $PWD/hooks/pre-command

  assert_success
  assert_output ""
}

@test "Upload a single directory" {
  export BUILDKITE_PLUGIN_CACHE_SAVE=tmp/caches/assets/*
  output=$(cat <<-EOF
~~~ Replacing command
echo "~~~ Saving caches"
printf "  %s\n" tmp/caches/assets/*
EOF
)

  run $PWD/hooks/pre-command

  assert_success
  assert_output "$output"
}

# @test "Upload several directories" {
#   export BUILDKITE_PLUGIN_CACHE_SAVE_0=tmp/caches/assets/*
#   export BUILDKITE_PLUGIN_CACHE_SAVE_1=public/assets/*

#   stub buildkite-agent \
#     "artifact upload tmp/caches/assets/* : echo uploaded tmp/caches/assets/*" \
#     "artifact upload public/assets/* : echo uploaded public/assets/*"

#   run $PWD/hooks/post-command

#   assert_success
#   assert_output --partial "uploaded tmp/caches/assets/*"
#   assert_output --partial "uploaded public/assets/*"
#   unstub buildkite-agent
# }
