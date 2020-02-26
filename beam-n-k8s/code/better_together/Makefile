REPO=quay.io/coryodaniel/better_together

.PHONY: all
all: docker destroy deploy logs

.PHONY: docker
docker: docker-build docker-push

.PHONY: docker-build
docker-build:
	docker build -t ${REPO}:latest -t ${REPO}:$(shell make version) .

.PHONY: docker-push
docker-push:
	docker push ${REPO}:latest
	docker push ${REPO}:$(shell make version)

.PHONY: version
version:
	@cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/'

.PHONY: deploy
deploy:
	kustomize build k8s/base | kubectl apply -f -

.PHONY: destroy
destroy:
	-kustomize build k8s/base | kubectl delete -f -

.PHONY: logs
logs:
	stern better --tail 5

POD_NAME:=$(shell kubectl get pods | grep better-together | head -n1 | awk '{print $$1}')
.PHONY: shell
shell:
	kubectl exec -it ${POD_NAME} -- /bin/sh