#!/bin/bash

upload() {
	url=https://github.com/rasa/$2.git
	printf "Uploading %s to %s\n" "$1" "${url}"
	pushd "$1" >/dev/null || exit
		git remote add origin "${url}"
		git push --force -u origin master
		git push --force --tags
	popd >/dev/null
}

upload keepass1      keepass1
upload keepass2      keepass2
upload translations1 keepass1_translations
upload translations2 keepass2_translations
