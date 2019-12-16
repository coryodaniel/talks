REPO=quay.io/coryodaniel/affinity

.PHONY: docker
docker: docker-build docker-push

.PHONY: all
all: docker base log

.PHONY: base
base:
	-kubectl delete -k ./manifests/base
	kubectl apply -k ./manifests/base

.PHONY: log
log:
	stern cpu-affinity

.PHONY: docker-build
docker-build:
	docker build -t ${REPO}:latest -t ${REPO}:$(shell make version) .

.PHONY: docker-push
docker-push:
	docker push ${REPO}:latest
	docker push ${REPO}:$(shell make version)

version:
	@cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/'

local-shell: docker-build
	docker run -it --entrypoint "/bin/sh" quay.io/coryodaniel/affinity:latest
