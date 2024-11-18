.ONESHELL: ; # recipes execute in same shell
.NOTPARALLEL: ; # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
.PHONY: all help
.DEFAULT: help # Running Make will run the help target

help: ## Show Help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

switch-helios:
	nixos-rebuild switch --flake ~/nix-configs#helios --target-host steixeira@helios --use-remote-sudo

build-phrike:
	nix build .#nixosConfigurations.phrike.config.system.build.toplevel

switch-phrike:
	nixos-rebuild switch --flake ~/nix-configs#phrike --target-host steixeira@phrike --use-remote-sudo

switch-m1pro:
	darwin-rebuild switch --flake .#m1pro

update:
	nix flake update
