SHELL := /bin/bash
RESTIC := $(shell command -v restic 2> /dev/null)

CRONTAB_INPUT := backup.cron
CRONTAB_BACKUP := tmp/crontab.bak
CRONTAB_TO_SET := tmp/crontab

default: help

.PHONY: install
install: ## Install a scheduled backup from this configuration
install: test cronjobs

.PHONY: backup
backup: ## Run a backup
backup:
	./backup.sh

.PHONY: clean
clean: ## Delete generated artifacts & reset to a clean state
	rm -f $(CRONTAB_TO_SET)
	rm -f $(CRONTAB_BACKUP)

.PHONY: test
test: ## Verify system is properly configured for backups
	@echo -n "Running tests… "
ifndef RESTIC
	$(error "restic is not available; please install")
endif
	@echo "OK"

$(CRONTAB_BACKUP): .FORCE
	@echo -n "Backing up crontab… "
	@touch $@
	@if crontab -l >/dev/null; then crontab -l > $@; fi
	@echo "OK"

$(CRONTAB_TO_SET): $(CRONTAB_BACKUP) $(CRONTAB_INPUT)
	@echo -n "Generating new cron table… "
	@cat $(CRONTAB_BACKUP) | grep -v "AndrewSardonePersonalBackup Job" > $@ || echo -n "" > $@
	@cat $(CRONTAB_INPUT) | awk '{print $$0, " # AndrewSardonePersonalBackup Job"}' >> $@
	@echo "OK"

.PHONY: cronjobs
cronjobs: tmp/crontab
	@echo -n "Installing cron commands…"
	@crontab $<
	@echo "OK"

.FORCE:

# via https://gist.github.com/prwhite/8168133
help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
