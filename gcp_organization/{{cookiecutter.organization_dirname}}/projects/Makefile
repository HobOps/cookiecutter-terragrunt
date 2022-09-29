include _vars.mk
SHELL:=bash

REQUIRED_BINS := sops terraform terragrunt tfenv tgenv
$(foreach bin,$(REQUIRED_BINS),\
    $(if $(shell command -v $(bin) 2> /dev/null),$(info Found `$(bin)`),$(error Please install `$(bin)`)))

help:
	@echo ======= Available commands =======
	@grep '^[a-z0-9].*:' Makefile | sed 's/://g'

.DEFAULT_GOAL := help

init: secrets-init apply-dependencies

apply-dependencies: create-project apply-vpc apply-network-addresses apply-service-accounts

create-project:
	@cd project; terragrunt apply

apply-vpc:
	@cd vpc; terragrunt apply

apply-network-addresses:
	@cd network-addresses; terragrunt apply

apply-service-accounts:
	@cd service-accounts; terragrunt apply

apply-all:
	@terragrunt run-all apply

secrets-init:
	@find _configuration -name '*.secrets.yaml' -exec sh -c 'sops -e -i {} || echo "====== Error: {} was already encrypted"' \;

secrets-edit:
	@if [ -z $(section) ]; then\
		echo "Error: 'section' is not defined"; exit 1;\
	fi
	@sops _configuration/$(section).secrets.yaml
