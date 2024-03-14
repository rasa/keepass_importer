#!/usr/bin/env make

PACKAGE?=keepass

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-10s %s\n", $$1, $$2}'

.PHONY: all
all: init download commit upload ## make init download commit upload

.PHONY: init
init:	## Initialize git directories in keepass
	./init.sh "$(PACKAGE)"

.PHONY: download
download:	## Download the latest keepass files from SourceForge
	./download.sh "$(PACKAGE)"

.PHONY: commit
commit:	## Commit changes
	./commit.sh "$(PACKAGE)"

.PHONY: upload
upload:	## Upload changes to GitHub
	./upload.sh "$(PACKAGE)"

.PHONY: clean
clean:	## Remove downloaded keepass files from SourceForge (optional)
	./clean.sh "$(PACKAGE)"
