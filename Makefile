.PHONY: up down test fmt

up:
	./scripts/deploy.sh

down:
	kind delete cluster --name status-page

test:
	terraform -chdir=terraform validate

fmt:
	terraform -chdir=terraform fmt -recursive
