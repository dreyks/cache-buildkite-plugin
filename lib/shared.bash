#!/bin/bash

# Reads either a value or a list from plugin config
function plugin_read_list() {
  local prefix="BUILDKITE_PLUGIN_CACHE_$1"
  local parameter="${prefix}_0"

  if [[ -n "${!parameter:-}" ]]; then
    local i=0
    local parameter="${prefix}_${i}"
    while [[ -n "${!parameter:-}" ]]; do
      echo "${!parameter}"
      i=$((i+1))
      parameter="${prefix}_${i}"
    done
  elif [[ -n "${!prefix:-}" ]]; then
    echo "${!prefix}"
  fi
}

function build_command_override_file() {
  printf "#!/bin/bash\n"
  printf "set -ueo pipefail\n\n"
  printf "echo \"~~~ Saving caches\"\n"

  for line in $(plugin_read_list SAVE) ; do
    printf "printf \"  %%s\\\n\" $line\n"
  done
}
