#!/usr/bin/env bash

# source: https://github.com/rasa/sourceforge-file-download/blob/master/sourceforge-file-downloader.sh

project="${1:-keepass}"
printf "Downloading %s's files\\n" "${project}"

# download all the pages on which direct download links are
# be nice, sleep a second
COMMON_WGET_OPTS=(
  --no-verbose
  --no-check-certificate
  -U Wget/1.24.5
)
# -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.3"
WGET_OPTS=(
  "${COMMON_WGET_OPTS[@]}"
  --wait 1
  --no-parent
  --mirror
  --accept download
)
wget "${WGET_OPTS[@]}" "http://sourceforge.net/projects/${project}/files/"

# extract those links
# shellcheck disable=SC2312
grep -Rh refresh sourceforge.net/ | grep -o "https:[^\\?]*" | sort -u >urllist

# shellcheck disable=SC2312
printf 'Downloading %d URLs\n' "$(wc -l <urllist)"

# remove temporary files, unless you want to keep them for some reason
# rm -r sourceforge.net/

WGET_OPTS=(
  "${COMMON_WGET_OPTS[@]}"
  --no-clobber
  --content-disposition
  --force-directories
  --no-host-directories
  --cut-dirs=1
)

# download each of the extracted URLs, put into $projectname/
while read -r url; do
  wget "${WGET_OPTS[@]}" "${url}"
done <urllist

# shellcheck disable=SC2312
mapfile -t < <(find . -type f -name '*@viasf=1')
for i in "${MAPFILE[@]}"; do
  mv -v "${i}" "${i/@viasf=1}"
done

# rm urllist

# cSpell:ignore projectname, viasf
