.DEFAULT_GOAL=help
BIN_NAME?=example-app
DOCKER_REPO?=coryodaniel/$(BIN_NAME)
VERSION?=latest
PORT?=8080

##@ Development
$(BIN_NAME): ## Compile binary
	go build

.PHONY: clean
clean: ## Cleanup
	rm -f $(BIN_NAME)	

.PHONY: dev.server
dev.server: ## Compile binary, build image, and run a server
dev.server: $(BIN_NAME) docker.stop docker.build docker.run

.phony: dev.job
dev.job: $(BIN_NAME) docker.stop docker.build
dev.job: ## Compile binary, build image, and run a job
	docker run --name $(BIN_NAME) -it $(DOCKER_REPO):$(VERSION) -mode job

##@ Docker
.PHONY: docker
docker: ## Build and push
docker: docker.build docker.push

.PHONY: docker.build
docker.build: ## Build docker image
	docker build -t $(DOCKER_REPO):$(VERSION) .

.PHONY: docker.run
docker.run: ## Run docker container
docker.run: docker.stop
	docker run --name $(BIN_NAME) -p $(PORT):$(PORT) -it $(DOCKER_REPO):$(VERSION) -listen-addr ":$(PORT)"

.PHONY: docker.shell
docker.shell: ## Run a shell
docker.shell: docker.stop docker.build
	docker run --name $(BIN_NAME) --entrypoint=sh -it $(DOCKER_REPO):$(VERSION)

.PHONY: docker.stop
docker.stop: ## Stop and rm container
	-@docker stop $(BIN_NAME)
	-@docker rm $(BIN_NAME)

.PHONY: docker.push
docker.push: ## Push image to quay
	docker push $(DOCKER_REPO):$(VERSION)

##@ Utility
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_.-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)