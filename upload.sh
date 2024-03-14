#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

set -xv

upload() {
  url="https://github.com/rasa/$2.git"
  printf 'Uploading %s to %s\n' "$1" "${url}"
  pushd "$1" >/dev/null || exit 1
  if ! git remote | grep -q -E ^origin; then
    git remote add origin "${url}"
  fi
  # git push --force --set-upstream origin master
  git push --force --all
  popd >/dev/null || exit 1
}

upload keepass1 keepass1
upload keepass2 keepass2
upload translations1 keepass1_translations
upload translations2 keepass2_translations
