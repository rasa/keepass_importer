#!/usr/bin/env bash

URLLIST="$(realpath urllist)"
EOLFIX="$(command -v eolfix)"

_pushd() {
	pushd "$1" >/dev/null || exit 1
}

_popd() {
	popd >/dev/null || exit 1
}

do_zip() {
	_pushd "${appname}"
		if [[ "${rm}" == "y" ]]; then
			git ls-files -z | xargs --no-run-if-empty -0 rm -f
		fi
		7z x -aoa -r -y "../${dir}/${app}/${ver}/${zip}" >/dev/null
		url="$(grep ${zip} "${URLLIST}")"
		if [[ -n "${EOLFIX}" ]]; then
			# list files that do not have unix (lf) line endings
			"${EOLFIX}" -i u
		fi
		file="$(find . -type f -not -path './.git/*' -printf '%T@\t%P\n'      | sort -nr | head -n 1 | cut -f 2-)"
		stat="$(stat --printf '%y' "${file}")"
		printf "%s %s\n" "${stat} ${file}"
		date="$(cut -d ' ' -f 1 <<<"${stat}")"
		time="$(cut -d ' ' -f 2 <<<"${stat}" | cut -d. -f 1)"
		zone="$(cut -d ' ' -f 3 <<<"${stat}")"
		stat="${date}T${time} ${zone}"
		printf "%s %s\n" "${stat} ${file}"
		git add .
		export GIT_AUTHOR_DATE="${stat}" 
		export GIT_COMMITTER_DATE="${GIT_AUTHOR_DATE}" 
		git commit -q -m "Release ${ver}: ${zip}

Source: ${url}"
		
	_popd
}

do_ver() {
	_pushd "${dir}/${app}/${ver}"
		mapfile -t zips < <( find . -type f -iname "${mask}" -printf "%T@\t%P\n" | sort -n | cut -f 2- )
	_popd
	for zip in "${zips[@]}"; do
		committed=".${dir}_${app}_${ver}_${zip}.committed"
		if [[ -e "${committed}" ]]; then
			continue
		fi
		printf "Processing %s\n" "$(stat --printf '%y %n' "${dir}/${app}/${ver}/${zip}")"
		do_zip
		touch "${committed}"
	done

	tagged=".${dir}_${app}_${ver}.tagged"
	if [[ -e "${tagged}" ]]; then
		return
	fi	
	_pushd "${appname}"
		git tag "v${ver}" -m "v${ver}"
	_popd
	touch "${tagged}"
}

do_app() {
	app="$1"
	mask="$2"
	rm="$3"

	appname="$(tr -d ' .x' <<<"${app}" | tr [A-Z] [a-z])"
	if [[ ! -d "${appname}" ]]; then
		printf "Creating directory %s\n" "${appname}"
		mkdir -p "${appname}"
		_pushd "${appname}"
			git init -q
		_popd
	fi
	_pushd "${dir}/${app}"
		mapfile -t vers < <( find . -mindepth 1 -maxdepth 1 -type d -printf '%P\n' )
	_popd
	for ver in "${vers[@]}"; do
		printf "Processing ver '%s'\n" "${ver}"
		do_ver
	done	
}

main() {
	dir="$1"

	printf "Processing dirs in '%s'\n" "${dir}"

	do_app "Keepass 1.x"      "*Src.zip"    "y"
	do_app "Keepass 2.x"      "*Source.zip" "y"
	do_app "Translations 1.x" "*.zip"       "n"
	do_app "Translations 2.x" "*.zip"       "n"
	#do_app "Plugins" "*.zip" 1
}

dir="$1"
if [[ -z "${dir}" ]]; then
	dir=keepass
fi

if [[ -e "${dir}.sh" ]]; then
	source "${dir}.sh"
fi

main "${dir}"
