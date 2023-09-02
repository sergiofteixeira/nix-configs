.ONESHELL: ; # recipes execute in same shell
.NOTPARALLEL: ; # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
.PHONY: all help 
.DEFAULT: help # Running Make will run the help target

help: ## Show Help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

upgrade-helios:
	nixos-rebuild switch --flake .#helios --upgrade --target-host steixeira@helios --use-remote-sudo

switch-helios:
	nixos-rebuild switch --flake .#helios --target-host steixeira@helios --use-remote-sudo

upgrade-phrike:
	nixos-rebuild switch --flake .#phrike --upgrade --target-host steixeira@phrike --use-remote-sudo

switch-phrike:
	nixos-rebuild switch --flake .#phrike --target-host steixeira@phrike --use-remote-sudo

update:
	nix flake update
