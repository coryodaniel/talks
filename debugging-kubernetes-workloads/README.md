---
# Built w/ https://marpit.marp.app/markdown
marp: true
theme: gaia

---

# Debugging
# Kubernetes 
# Workloads

![bg](./assets/boat-and-excavator.jpg)

---

<!-- class: gaia -->

## In This Tutorial

* Review common Kubernetes resource types and spec fields
* Deploy an application and expose it as an HTTP service
* Use kubectl to diagnose common Kubernetes configuration issues

---

## Helpers!

* At any point you can reset your environment by running:
  * `make clean`
* Set aliases!
  * `alias k=kubectl`
  * `alias kd="kubectl describe"`
  * `alias derp="kubectl get deployments,replicasets,pods"`

---

## Review Common Kubernetes Resources

TODO: Image, abstractions all the way down
TODO: note fields for each scenario

* deployment
* replicaset
* pod
* service
* endpoint

---

## Why Workloads Fail 

* Pods fail to get scheduled or becoming "ready"
* Services fail to route traffic
* Application errors

<!--

There are three major areas for workload failure in Kubernetes, being able to quickly identify _where_ a failure is happening can be difficult.
-->

---

## The Ecosystem is 🔥 

<!--

It seems like everyday there is a new open source project or SaaS being launched for kubernetes debugging.

These are just a few tools I have installed / use.

-->

* In cluster tools ([kubebox](https://github.com/astefanutti/kubebox))
* 3rd party binaries ([telepresence](https://www.telepresence.io/), [stern](https://github.com/wercker/stern), [k9s](https://github.com/derailed/k9s))
* kubectl [plugins](https://github.com/ishantanu/awesome-kubectl-plugins#kubectl-plugins) ([dig](https://github.com/sysdiglabs/kubectl-dig), [tree](https://github.com/ahmetb/kubectl-tree), [bpftrace](https://github.com/iovisor/kubectl-trace))
* SaaS ([rookout](https://www.rookout.com/))


---

## kubectl is your 🧰 

<!--

kubectl has a lot of tools to aid in debugging.

Knowing the basics of kubectl can go a long way towards quickly resolving issues in a k8s cluster

-->

* `kubectl get` - basic information
* `kubectl describe` - exhaustive details
* `kubectl log` - container logs
* `kubectl get events` - cluster events
* `kubectl explain` - resource and field documentation
* `kubectl port-forward` - bind local ports to kubernetes pods and services
* `kubectl exec` - remote shell access
* `kubectl debug` - debug containers

---

## Failing Pods

![bg](./assets/rusty-bucket.jpeg)

<!-- 


* k explain pod.status.containerStatuses.state
* k explain pod.status.phase

Links:
* https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application-introspection/
* https://kubernetes.io/docs/tasks/debug-application-cluster/debug-pod-replication-controller/


Events are always a good place to check kubectl describe pod|service <name> or kubectl get events

-->

---

### `Pending` Pods

> PENDING means that it can not be scheduled onto a node.

Setup:

`kubectl apply -f manifests/1-node-resources.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe pods/POD_NAME_HERE`

<!--

Using get with multiple resource types, we can see the deployment and replica set were
create, but the pod is PENDING.

Lets look at the details of the pod.

NEXT

-->

---

### `Pending` Pods :: Insufficient Node Resources

```
Containers:
  spotty:
    Image:      coryodaniel/spotty-server:latest
    Port:       <none>
    Host Port:  <none>
    Requests:
      cpu:        500m
      memory:     50G
Conditions:
  Type           Status
  PodScheduled   False
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  91s   default-scheduler  0/1 nodes are available: 1 Insufficient memory.
```

<!--

We can see under events that the node doesn't have enough memory for this workload.

Looking at the requests, we can see someone typed "50G" instead of "50Mi"

Lets fix that memory request

-->

---

### `NO` Pods!?


Setup:

`kubectl apply -f manifests/2-quotas.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe replicasets/RS_NAME_HERE`

<!--

If we run the same get command again, we'll see that we dont have ANY pods this time.

When debugging Kubernetes resources remember the layers of abstraction is important.

Here we dont have any pods... so the issue must be a layer up.

Lets describe the replica set.

-->

---

### `NO` Pods!? :: Resource Quotas

```
Limits:
  cpu:     1
  memory:  100Mi
Requests:
  cpu:        500m
  memory:     50Mi
```

> replicaset-controller  Error creating: pods "spotty-6f6c9bf7d5-v26m4" is forbidden: exceeded quota: default-quota, requested: requests.cpu=500m, used: requests.cpu=0, limited: requests.cpu=50m


<!-- 

In this scenario we exceeding a CPU quota applied to our namespace. If you examine the YAML file you'll see
that a resource quota was applied that said the maximum total request size for a containers CPU is 50m, but we requested 500m.

Many other issues causing PENDING pods including:

* Taints & affinities
* PENDING PVCs
* Scheduler or kubelet errors -->

---

### Scheduled, not `RUNNING`

Setup:

`kubectl apply -f manifests/3-crashing-app.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe pods/POD_NAME`
* `kubectl logs POD_NAME`

```
spotty-5bbb8dbf54-9mvfr   0/1     CrashLoopBackOff   4          2m35s
```

<!--
Here we can see that a pod is getting scheduled, but its failing to RUN.

Lets describe the pods details.
-->

---

### Scheduled, not `RUNNING` :: Application Error

```
Node:         docker-desktop/192.168.65.4
Containers:
    State:          Terminated
      Reason:       Error
      Exit Code:    1
      Started:      Mon, 14 Jun 2021 22:24:54 -0700
      Finished:     Mon, 14 Jun 2021 22:24:54 -0700
    Ready:          False
    Restart Count:  2
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Events:
  Type     Reason     Age               From               Message
  ----     ------     ----              ----               -------
  ...
  Warning  BackOff    2s (x3 over 18s)  kubelet            Back-off restarting failed container
```

<!--
Looking at the details output we can see a few things:

* It was scheduled to a node
* The container is terminated due to an exit code of one
* There is a BackOff event happening because the container is failing repeatedly

Lets see if we can get some container logs
-->

---

## Scheduled, not `RUNNING` :: Getting Logs

Tools:
* `kubectl logs POD_NAME`
* `kubectl logs POD_NAME --previous`
* `kubectl logs POD_NAME -c CONTAINER_NAME`
* `kubectl logs POD_NAME --all-containers=true`

```
Starting server on :8080
Something janky happened!
```

<!--
Sometime containers fail so fast they dont log any details, you can use the --previous flag to pull logs from a previous container that failed in the Crash back off loop.

We can see that something janky happened. This is actually a flag to the binary that I added to cause the app to crash for demonstration purposes. Lets remove that flag.

Links:
* https://kubernetes.io/docs/tasks/debug-application-cluster/determine-reason-pod-failure/

Other issues causing CrashLoopBackOff

* Wrong docker command
* Application errors
* Bad livenessprobe
  
-->

---

## Images Fail to Pull

Setup:

`kubectl apply -f manifests/4-bad-image.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe pods/POD_NAME`

---

<!--
Here we can clearly see there is an error fetching the image.

You might see ErrImagePull or ImagePullBackOff depending on how many failures have occurred.

In this case, if we look at the YAML we can see the docker image tag is "lol." Thats not a real tag.

* Invalid docker repo credentials (ImagePullSecrets)
* Bad image name or label
* Docker rate limiting :D
-->

## Images Fail to Pull :: Image Not Found

```
Containers:
  spotty:
    Image:          coryodaniel/spotty-server:lol
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
Events:
  Type     Reason          Age                    From               Message
  ----     ------          ----                   ----               -------
  Normal   Pulling         4m9s (x2 over 4m23s)   kubelet            Pulling image "coryodaniel/spotty-server:lol"
  Warning  Failed          4m7s (x2 over 4m22s)   kubelet            Failed to pull image "coryodaniel/spotty-server:lol": rpc error:
  Warning  Failed          4m7s (x2 over 4m22s)   kubelet            Error: ErrImagePull
  Normal   SandboxChanged  3m55s (x7 over 4m21s)  kubelet            Pod sandbox changed, it will be killed and re-created.
  Normal   BackOff         3m51s (x6 over 4m17s)  kubelet            Back-off pulling image "coryodaniel/spotty-server:lol"
  Warning  Failed          3m51s (x6 over 4m17s)  kubelet            Error: ImagePullBackOff
```

---

## Pods is `RUNNING`, but not `READY`

`RUNNING` the container's entrypoint/command started
`READY` it can accept traffic

Setup:

`kubectl apply -f manifests/5-not-ready.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe pods/POD_NAME`
* `kubectl logs POD_NAME`

<!--

RUNNING vs READY

* A pod with no readiness probe is READY by default once RUNNING
* If a readiness probe is defined, the pod will get into RUNNING, then once the probe passes it will be come READY for traffic

-->

---

<!--

When we get the pod we can see that the status is running but 0/1 of the containers in the pod are ready... 

If we look at the logs we can see some 500 errors/

YMMV: If we look at the YAML we'll see a readiness probe configured. The URL path "/spotty" returns errors 80% of the time.

-->

## Pods is `RUNNING`, but not `READY` :: Logs

`kubectl get pods`:
```
NAME                          READY   STATUS    RESTARTS   AGE
pod/spotty-76c5c5874f-b4jtq   0/1     Running   0          6s
```

`kubectl log POD_NAME`:
```
Starting server on :8080
[GET] 500 /spotty
[GET] 500 /spotty
[GET] 200 /spotty
```

---

## Pods is `RUNNING`, but not `READY` :: Readiness

<!--

If we describe the pod, we can see a number of important details:

* We can see the state is RUNNING and the started time
* We can see the details of the readiness probe
* We can see the Condition READY is False
* We can see Unhealthy warnings in the event log

Kubernetes will not send traffic to this pod while its unhealthy!

Lets fix that!
-->

`kubectl describe pods/POD_NAME`

```
Containers:
  spotty:
    Image:          coryodaniel/spotty-server:latest
    State:          Running
      Started:      Mon, 14 Jun 2021 22:58:15 -0700
    Ready:          False
    Restart Count:  0
    Readiness:    http-get http://:8080/spotty delay=3s timeout=1s period=5s #success=1 #failure=3
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   True
  PodScheduled      True
Events:
  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
  Warning  Unhealthy  107s (x21 over 3m57s)  kubelet            Readiness probe failed: HTTP probe failed with statuscode: 500
```

---

## Port forwarding a `READY` pod 

<!--

In scenarios where traffic isn't routing correctly to the pod, port-forwarding directly to a pod can help rule out an issue with that pod.

After forwarding the port, you should be able to browse to localhost and see your app.

If port forwarding fails you'll see "connection refused" or a similar message in your console. Generally if an app is READY but the port cannot be forwarded it means the app is listening on the wrong port or IP

-->

Setup:

`kubectl apply -f manifests/6-one-fine-app.yaml`

Tools:

* `kubectl port-forward pod/POD_NAME_HERE PORT_ON_YOUR_MACHINE:8080`
  
When port-forwarding fails:
* the app is listening on a different port than you forwarded
* the app is listening on an IP address besides `0.0.0.0`
