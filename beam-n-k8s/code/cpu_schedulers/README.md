# CPUs & Schedulers

Erlang starts schedulers for the number of CPUs or vCPUs on the node rather than the number set in `spec.template.spec.containers.resources.limits.cpu` or `spec.template.spec.containers.resources.requests.cpu`

*  Setting Kubernetes resource requests/limits; Guaranteed QoS
*  Setting `+S`

## Setup

This will deploy ./manifests/base to kubectl's current-context:

```shell
make deploy
```

Tail the deployments logs:

```shell
stern cpu-schedulers
```

You should see that the number of schedulers is equal to the machines CPU (or vCPU) count and _not_ the resource requests/limits defined in [`./manifests/base/deployment.yaml`](./manifests/base/deployment.yaml)

## Building

```shell
REPO=my-docker-repo-url make docker
```

Optionally use this [docker image](https://quay.io/repository/coryodaniel/cpu-schedulers).