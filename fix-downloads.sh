#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

# shellcheck disable=SC2312
mapfile -t < <(find . -type f -name '*@*')

for file in "${MAPFILE[@]}"; do
  dir=$(dirname "${file}")
  base=$(basename "${file}")
  fix=$(cut -d@ -f 1 <<<"${base}")
  pushd "${dir}" >/dev/null || exit 1
  if [[ -f "${fix}" ]]; then
    printf "Link to %s OK\n" "${file}"
  else
    printf "Linking %s\n" "${file}"
  fi
  cp -l -n -v "${base}" "${fix}"
  popd >/dev/null || exit 1
done

# shellcheck disable=SC2312
mapfile -t < <(find . -type f -size 0 -name '*.zip')
for file in "${MAPFILE[@]}"; do
  printf "Removing zero byte file %s\n" "${file}"
  rm -f "${file}"
done
