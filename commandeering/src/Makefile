help: ## Show this help
	@grep -E '^[a-zA-Z0-9._-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all 
all: ## Create CRD, resources, and display details
all: crd todos list get details

.PHONY: clean
clean: ## Destroy all resources created by this Makefile
	kubectl delete --all todos
	kubectl delete crd/todos.todo-operator.bonny.run

.PHONY: crd
crd: ## Create the Todo CR
	kubectl apply -f ./yaml/crd.yaml

.PHONY: todos
todos: ## Create a list of Todos
	kubectl apply -f ./yaml/todos.yaml

.PHONY: list
list: ## List all Todos
	kubectl get todos

.PHONY: get
get: ## Get the create-slideshow Todo
	kubectl get todo/create-slideshow

.PHONY: details
details: ## Get details of the create-slideshow Todo
	kubectl get todo/create-slideshow -o yaml

.PHONY: edit
edit: ## Open the default editor w/ the create-demo Todo
	kubectl edit todo/create-demo

.PHONY: invalid
invalid: ## Try to create invalid Todos
	kubectl apply -f ./yaml/invalid.yaml