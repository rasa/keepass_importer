#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

rm -fr keepass1
rm -fr keepass2
rm -fr translations1
rm -fr translations2
rm -fr plugins
rm -fr sourceforge.net
rm -fr urllist
