REPO?=quay.io/coryodaniel/cpu-schedulers

.PHONY: docker
docker: docker-build docker-push

.PHONY: all
all: docker deploy logs

.PHONY: deploy
deploy:
	-kubectl delete -k ./manifests/base
	kubectl apply -k ./manifests/base

.PHONY: logs
logs:
	(which stern && stern cpu-schedulers) || kubectl logs deployment/cpu-schedulers -f
	
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
	docker run -it --entrypoint "/bin/sh" quay.io/coryodaniel/cpu-schedulers:latest
