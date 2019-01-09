#!/bin/sh
# source: https://github.com/rasa/sourceforge-file-download/blob/master/sourceforge-file-downloader.sh
display_usage() {
  echo "Downloads all of a SourceForge project's files."
  echo "\nUsage: ./sourceforge-file-download.sh [project name] \n"
}

if [ $# -eq 0 ]
then
  display_usage
  exit 1
fi

project=$1
echo "Downloading $project's files"

# download all the pages on which direct download links are
# be nice, sleep a second
#wget --wait 1 --no-parent --mirror --accept download http://sourceforge.net/projects/$project/files/

# extract those links
grep -Rh refresh sourceforge.net/ | grep -o "https:[^\\?]*" | sort -u > urllist

printf "Downloading %d URLs\n" "$(wc -l < urllist)"

# remove temporary files, unless you want to keep them for some reason
# rm -r sourceforge.net/

# download each of the extracted URLs, put into $projectname/
while read url; do wget -U Wget/1.19.1 --no-clobber --content-disposition --force-directories --no-host-directories --cut-dirs=1 "${url}"; done < urllist

# rm urllist
