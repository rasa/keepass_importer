# Makefile

PACKAGE?=keepass

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: download commit upload ## make download commit upload

.PHONY: download
download:	## Download the latest keepass files from SourceForge
	./sourceforge-file-downloader.sh "$(PACKAGE)"

.PHONY: commit
commit:	## Commit changes
	./commit.sh "$(PACKAGE)"

.PHONY: upload
upload:	## Upload changes to GitHub
	./upload.sh "$(PACKAGE)"

.PHONY: clean
clean:	## Remove downloaded keepass files from SourceForge (optional)
	./clean.sh "$(PACKAGE)"
