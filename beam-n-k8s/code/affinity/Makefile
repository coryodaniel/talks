REPO=quay.io/coryodaniel/affinity

.PHONY: all
all: docker

.PHONY: docker
docker: docker-build docker-push

.PHONY: docker-build
docker-build:
	docker build -t ${REPO}:latest -t ${REPO}:$(shell make version) .

.PHONY: docker-push
docker-push:
	docker push ${REPO}:latest
	docker push ${REPO}:$(shell make version)

version:
	@cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/'
