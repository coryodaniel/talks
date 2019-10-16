REPO=quay.io/coryodaniel/todo-operator

.PHONY: all
all: docker k8s-manifest

.PHONY: docker
docker: docker-build docker-push

.PHONY: docker-build
docker-build:
	docker build -t ${REPO}:latest -t ${REPO}:$(shell make version) .

.PHONY: docker-push
docker-push:
	docker push ${REPO}:latest
	docker push ${REPO}:$(shell make version)

.PHONY: k8s-manifest
k8s-manifest:
	mix bonny.gen.manifest --image=${REPO}:$(shell make version)

version:
	@cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/'