#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

test ! -d keepass &&
  mkdir keepass

# 1980-01-01 00:00:00 GMT
epoch=315532800
export GIT_AUTHOR_DATE=$(TZ=UTC date +%c --date="@${epoch}")
export GIT_COMMITTER_DATE="${GIT_AUTHOR_DATE}"

for dir in keepass1 keepass2 translations1 translations2; do
  if [[ ! -d "${dir}" ]]; then
    mkdir "${dir}"
    pushd "${dir}" >/dev/null || exit 1
    git init
    git commit --allow-empty -m "Initial commit"
    popd >/dev/null || exit 1
  fi
done

# test ! -d keepass1 &&
#   gh repo clone rasa/keepass1
# test ! -d keepass2 &&
#   gh repo clone rasa/keepass2
# test ! -d translations1 &&
#   gh repo clone rasa/keepass1_translations translations1
# test ! -d translations2 &&
#   gh repo clone rasa/keepass1_translations translations2
