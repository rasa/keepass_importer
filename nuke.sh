#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

./clean.sh

rm -fr keepass
rm -fr .touches
