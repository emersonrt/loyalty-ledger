TF        := terraform -chdir=terraform
APP_DIR   ?= ../loyalty-ledger
CLUSTER   ?= loyalty-ledger
NODE      := $(CLUSTER)-control-plane
APP_IMAGE := loyalty-ledger:dev

.PHONY: help up down nuke image cluster load-image cluster-destroy

help: ## List the commands
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-16s %s\n", $$1, $$2}'

# ---------- Local environment (docker compose)
up: ## Start Postgres, Kafka, Debezium Connect, and Redis, and register the outbox connector
	docker compose up -d --wait postgres kafka kafka-connect redis
	docker compose up -d register-connector

down: ## Stop the containers (keeps the data)
	docker compose down

nuke: ## Stop everything and delete the volumes
	docker compose down -v

# ---------- Local cluster (kind + Traefik + Argo CD via Terraform)
image: ## Build the application image
	docker build -t $(APP_IMAGE) $(APP_DIR)

cluster: image ## Create/update the cluster and load the application image
	$(TF) init -input=false
	$(TF) apply
	$(MAKE) load-image

# No dependency on the kind CLI: imports directly into the node's containerd.
load-image: ## Load the local image into the kind node
	docker save $(APP_IMAGE) | docker exec -i $(NODE) ctr -n k8s.io images import -

cluster-destroy: ## Destroy the cluster
	$(TF) destroy
