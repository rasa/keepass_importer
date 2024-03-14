#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

URLLIST="$(realpath urllist)"
SEVENZIP="$(command -v 7z || true)"
EOLFIX="$(command -v eolfix || true)"

if [[ -z "${SEVENZIP:-}" ]]; then
  printf '%s: 7z is required\n' "$0" >&2
  exit 1
fi

GIT=(git -c core.safecrlf=false)

_pushd() {
  pushd "$1" >/dev/null || exit 1
}

_popd() {
  popd >/dev/null || exit 1
}

do_zip() {
  _pushd "${appname}"
  if [[ "${rm}" == "y" ]]; then
    # shellcheck disable=SC2312
    "${GIT[@]}" ls-files -z | xargs --no-run-if-empty -0 rm -f
  fi
  # printf 'Unzipping %s into %s/%s\n' "../${dir}/${app}/${ver}/${zip}" "$(pwd)"
  cmd=("${SEVENZIP}" x -aoa -r -y "../${dir}/${app}/${ver}/${zip}")
  printf -v cmdline "%s " "${cmd[@]}"
  printf 'Executing: %s\n' "${cmdline}"
  # "${SEVENZIP}" x -aoa -r -y "../${dir}/${app}/${ver}/${zip}" >/dev/null
  if ! "${cmd[@]}" >/dev/null; then
    printf 'Error %d returned by %s\n' "$?" "${cmdline}" >&2
    exit 1
  fi
  if [[ -n "${EOLFIX}" ]]; then
    # list files that do not have unix (lf) line endings
    "${EOLFIX}" -i u || true
  fi
  # shellcheck disable=SC2312
  file=$(
    find . -type f -not -path './.git/*' -printf '%T@\t%P\n' |
    sort -nr |
    head -n 1 |
    cut -f 2-
  ) || true
  printf 'file=%s\n' "${file}"
  # %y: time of last data modification, human-readable
  stat="$(stat --printf '%y' "${file}")"
  printf '%s %s\n' "${stat}" "${file}"
  date="$(cut -d ' ' -f 1 <<<"${stat}")"
  # shellcheck disable=SC2312
  time="$(cut -d ' ' -f 2 <<<"${stat}" | cut -d. -f 1)"
  zone="$(cut -d ' ' -f 3 <<<"${stat}")"
  stat="${date}T${time} ${zone}"
  printf '%s %s\n' "${stat}" "${file}"
  "${GIT[@]}" add .
  "${GIT[@]}" update-index --refresh
  "${GIT[@]}" diff-index HEAD --
  if "${GIT[@]}" diff-index --quiet HEAD --; then
    _popd
    return
  fi
  url="$(grep "${zip}" "${URLLIST}")"
  printf 'Executing: %s (%s)\n' "git commit -m 'Release ${ver}: ${zip}' / Source: ${url}" "GIT_AUTHOR_DATE=${stat}"
  export GIT_AUTHOR_DATE="${stat}"
  export GIT_COMMITTER_DATE="${GIT_AUTHOR_DATE}"
  "${GIT[@]}" commit -q -m "Release ${ver}: ${zip}

Source: ${url}"
  _popd
}

do_ver() {
  _pushd "${dir}/${app}/${ver}"
  # shellcheck disable=SC2312
  mapfile -t zips < <(
    find . -type f -iname "${mask}" -printf "%T@\\t%P\\n" |
    sort -n |
    cut -f 2-
  )
  _popd

  printf 'Processing %d files matching %s in %s\n' "${#zips[@]}" "${mask}" "${dir}/${app}/${ver}"
  for zip in "${zips[@]}"; do
    committed=".touches/.${dir}_${app}_${ver}_${zip}.committed"
    if [[ -e "${committed}" ]]; then
      continue
    fi
    # %y: time of last data modification, human-readable
    # %n: file name
    # shellcheck disable=SC2312
    printf 'Processing %s\n' "$(stat --printf '%y %n' "${dir}/${app}/${ver}/${zip}")"
    do_zip
    touch "${committed}"
  done

  tagged=".touches/.${dir}_${app}_${ver}.tagged"
  if [[ -e "${tagged}" ]]; then
    return
  fi
  _pushd "${appname}"
  # shellcheck disable=SC2312
  if ! "${GIT[@]}" tag | grep -q -E "\bv${ver}\b"; then
    printf 'Executing: %s\n' "git tag v${ver} -m v${ver}"
    "${GIT[@]}" tag "v${ver}" -m "v${ver}"
  fi
  _popd
  touch "${tagged}"
}

do_app() {
  app="$1"
  mask="$2"
  rm="$3"

  # shellcheck disable=SC2312
  appname="$(tr -d ' .x' <<<"${app}" | tr '[:upper:]' '[:lower:]')"
  if [[ ! -d "${appname}" ]]; then
    printf 'Directory not found: %s\n' "${appname}"
    exit 1
  fi
  _pushd "${dir}/${app}"
    # shellcheck disable=SC2312
    mapfile -t vers < <(find . -mindepth 1 -maxdepth 1 -type d -printf '%P\n' | sort -n)
  _popd
  printf "Processing %d versions in %s\n" "${#vers[@]}" "${dir}/${app}"
  for ver in "${vers[@]}"; do
    printf 'Processing ver "%s"\n' "${ver}"
    do_ver
  done
}

main() {
  dir="$1"

  if [[ ! -d .touches ]]; then
    mkdir .touches
  fi

  printf 'Processing dirs in "%s"\n' "${dir}"

  do_app "KeePass 1.x" "*Src.zip" "y"
  do_app "KeePass 2.x" "*Source.zip" "y"
  do_app "Translations 1.x" "*.zip" "n"
  do_app "Translations 2.x" "*.zip" "n"
  #do_app "Plugins" "*.zip" 1
}

dir="${1:-keepass}"

if [[ -e "${dir}.sh" ]]; then
  # shellcheck source=/dev/null
  source "${dir}.sh"
fi

main "${dir}"

# cSpell:ignore mindepth, safecrlf, SEVENZIP
