PACKAGE?=keepass

.PHONY: all
all: download commit upload

.PHONY: download
download:
	./sourceforge-file-downloader.sh "$(PACKAGE)"

.PHONY: commit
commit:
	./commit.sh "$(PACKAGE)"

.PHONY: upload
upload:
	./upload.sh "$(PACKAGE)"
