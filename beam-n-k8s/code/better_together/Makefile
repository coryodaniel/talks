REPO:=quay.io/coryodaniel/better_together
GKE_CLUSTER_NAME:=better-together-demo-cluster
GKE_INSTANCE_SIZE:=n1-standard-8
GKE_LOCATION:=--zone us-central1-c

guard-%: # Creates an environment variable requirement by setting a prereq of guard-YOUR_ENV_VAR
	@ if [ -z '${${*}}' ]; then \
		echo "Environment variable $* not set"; \
		exit 1;\
	fi

help: ## Show this help.
	@grep -E '^[a-zA-Z0-9._-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: ## Build and push docker, deploy kubernetes manifests, and tail pods
all: docker destroy deploy logs

.PHONY: docker
docker: ## Build and push docker image
docker: docker.build docker.push

.PHONY: docker.build
docker.build: ## Build docker image
	docker build -t ${REPO}:latest -t ${REPO}:$(shell make version) .

.PHONY: docker.push
docker.push: ## Push docker image
	docker push ${REPO}:latest
	docker push ${REPO}:$(shell make version)

.PHONY: version
version: ## Show better_together application version
	@cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/'

.PHONY: deploy
deploy: ## Create base deployment
	kustomize build k8s/base | kubectl apply -f -

.PHONY: destroy
destroy: ## Destroy base deployment
	-kustomize build k8s/base | kubectl delete -f -

.PHONY: logs
logs: ## Tail logs
	stern better --tail 5

POD_NAME=$(shell kubectl get pods | grep better-together | head -n1 | awk '{print $$1}')
.PHONY: shell
shell: ## Open a shell on a random running pod
	kubectl exec -it ${POD_NAME} -- /bin/sh

SVC_NODE_PORT=$(shell kubectl get svc/better-together-web -o=jsonpath='{.spec.ports[0].nodePort}')
.PHONY: open
open: ## Open localhost service port (local dev only)
	open http://localhost:${SVC_NODE_PORT}

.PHONY: cluster.create
cluster.create: guard-GCP_PROJECT_ID
cluster.create: ## Create demo GKE cluster
	gcloud beta container --project "${GCP_PROJECT_ID}" clusters create "${GKE_CLUSTER_NAME}" ${GKE_LOCATION} \
		--no-enable-basic-auth --release-channel "rapid" --machine-type "${GKE_INSTANCE_SIZE}" \
		--image-type "COS" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true \
		--scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write", \
		"https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol", \
		"https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
		--num-nodes "3" --enable-stackdriver-kubernetes --enable-ip-alias \
		--network "projects/boreal-mode-269823/global/networks/default" --subnetwork "projects/boreal-mode-269823/regions/us-central1/subnetworks/default" \
		--default-max-pods-per-node "110" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade \
		--enable-autorepair --enable-vertical-pod-autoscaling
	gcloud container clusters get-credentials "${GKE_CLUSTER_NAME}" ${GKE_LOCATION}

.PHONY: cluster.destroy
cluster.destroy: guard-GCP_PROJECT_ID
cluster.destroy: ## Destroy demo GKE cluster
	gcloud beta container --project ${GCP_PROJECT_ID} clusters delete "${GKE_CLUSTER_NAME}" ${GKE_LOCATION}