#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

VERSIONS=()
# these do not exist:
# VERSIONS+=(2.00-Alpha)
# VERSIONS+=(2.01-Alpha)
# VERSIONS+=(2.02-Alpha)
# VERSIONS+=(2.03-Alpha)
# VERSIONS+=(2.04-Alpha)
# VERSIONS+=(2.05-Alpha)
# VERSIONS+=(2.06-Beta)
# VERSIONS+=(2.07-Beta)
# VERSIONS+=(2.00)
# VERSIONS+=(2.01)
# VERSIONS+=(2.02)
VERSIONS+=(2.03)
VERSIONS+=(2.04)
VERSIONS+=(2.05)
VERSIONS+=(2.06)
VERSIONS+=(2.07)
VERSIONS+=(2.08)
VERSIONS+=(2.09)
VERSIONS+=(2.10)
VERSIONS+=(2.11)
VERSIONS+=(2.12)
VERSIONS+=(2.13)
VERSIONS+=(2.14)
VERSIONS+=(2.15)
VERSIONS+=(2.16)
VERSIONS+=(2.17)
VERSIONS+=(2.18)
VERSIONS+=(2.19)
VERSIONS+=(2.20)
VERSIONS+=(2.20.1)
VERSIONS+=(2.21)
VERSIONS+=(2.22)
VERSIONS+=(2.23)
VERSIONS+=(2.24)
VERSIONS+=(2.25)
VERSIONS+=(2.26)
VERSIONS+=(2.27)
VERSIONS+=(2.28)
VERSIONS+=(2.29)
VERSIONS+=(2.30)
VERSIONS+=(2.31)
VERSIONS+=(2.32)
VERSIONS+=(2.33)
VERSIONS+=(2.34)
VERSIONS+=(2.35)
VERSIONS+=(2.36)
VERSIONS+=(2.37)
VERSIONS+=(2.38)
VERSIONS+=(2.39)
VERSIONS+=(2.39.1)
VERSIONS+=(2.40)
VERSIONS+=(2.41)
VERSIONS+=(2.42)
VERSIONS+=(2.42.1)
VERSIONS+=(2.43)
VERSIONS+=(2.44)
VERSIONS+=(2.45)
VERSIONS+=(2.46)
VERSIONS+=(2.47)
VERSIONS+=(2.48)
VERSIONS+=(2.48.1)
VERSIONS+=(2.49)
VERSIONS+=(2.50)
VERSIONS+=(2.51)
VERSIONS+=(2.51.1)
VERSIONS+=(2.52)
VERSIONS+=(2.53)
VERSIONS+=(2.54)
VERSIONS+=(2.55)
VERSIONS+=(2.56)

test -d kpscript || mkdir kpscript
pushd kpscript || exit 1
rm -f urllist
for v in "${VERSIONS[@]}"; do
	zip="KPScript-${v}.zip"
	url="https://keepass.info/extensions/v2/kpscript/${zip}"
	test -f "${zip}" || wget "${url}"
	test -f "${zip}" && printf '%s\n' "${url}" >>urllist
done
popd || exit 1

# cSpell:ignore kpscript
