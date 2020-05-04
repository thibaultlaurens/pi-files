.DEFAULT_GOAL := help

.PHONY: checks
checks:		## Run static analysis tool.
	shellcheck -e SC1090 ./*.sh ./**/*.sh ./**/.bash_aliases

.PHONY: help
help:		## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
