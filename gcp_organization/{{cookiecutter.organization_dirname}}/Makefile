#include _vars.mk
SHELL:=bash

REQUIRED_BINS := sops terraform terragrunt tfenv tgenv cookiecutter
$(foreach bin,$(REQUIRED_BINS),\
    $(if $(shell command -v $(bin) 2> /dev/null),$(info Found `$(bin)`),$(error Please install `$(bin)`)))

help:
	@echo ======= Available commands =======
	@grep '^[a-z0-9].*:' Makefile | sed 's/://g'

.DEFAULT_GOAL := help

init:
	@echo init

create-project:
	@cookiecutter https://github.com/HobOps/cookiecutter-terragrunt --directory gcp_project -o projects
