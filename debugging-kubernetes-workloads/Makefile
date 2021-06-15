.PHONY: up
up: apply port-forward

.PHONY: clean
clean:
	-kubectl delete service/spotty
	-kubectl delete deployment/spotty
	-kubectl delete limitrange/default-limit
	-kubectl delete resourcequota/default-quota

.PHONY: apply
apply:
	kubectl apply -f manifests/final-app.yaml

.PHONY: port-forward
port-forward:
	kubectl port-forward svc/spotty 8080:8080