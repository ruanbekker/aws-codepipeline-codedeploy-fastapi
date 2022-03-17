# Thanks: https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
up: ## Runs the containers in detached mode
	docker-compose up -d --build

seed: ## Creates db entries
	curl -XPOST http://localhost:8000/seed

list: ## List all the entries from the db
	curl -s http://localhost:8000/students

down: ## Stops the container
	docker-compose down

