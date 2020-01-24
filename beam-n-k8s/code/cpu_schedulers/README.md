# CPUs & Schedulers

Erlang starts schedulers for the number of CPUs or vCPUs on the node rather than the number set in `spec.template.spec.containers.resources.limits.cpu` or `spec.template.spec.containers.resources.requests.cpu`.

## Setup

This will deploy ./manifests/base to kubectl's current-context:

```shell
make deploy
# kubectl apply -k ./manifests/base
```

Tail the deployments logs:

```shell
make logs
# kubectl logs deployment/cpu-schedulers -f
```

You should see that the number of schedulers is equal to the machines CPU (or vCPU) count and _not_ the resource requests/limits defined in [`./manifests/base/deployment.yaml`](./manifests/base/deployment.yaml)

Setting `+S 2:2` in [`rel/vm.args.eex`](rel/vm.args.eex) will set the correct number of schedulers.

## Building

```shell
REPO=my-docker-repo-url make docker
```

Optionally use this [docker image](https://quay.io/repository/coryodaniel/cpu-schedulers).