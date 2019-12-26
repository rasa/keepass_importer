#!/bin/bash

upload() {
  url=https://github.com/rasa/$2.git
  printf "Uploading %s to %s\n" "$1" "${url}"
  pushd "$1" >/dev/null || exit
  if ! git remote | grep -q -E ^origin; then
    git remote add origin "${url}"
  fi
  git push -u origin master
  git push --tags
  popd >/dev/null
}

upload keepass1 keepass1
upload keepass2 keepass2
upload translations1 keepass1_translations
upload translations2 keepass2_translations
