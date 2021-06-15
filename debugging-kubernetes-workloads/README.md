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
  * `alias first-pod="kubectl get pods -o=jsonpath='{.items[0].metadata.name}'"`

---

## Quick Review - Common k8s Resources

* deployments - create replicasets, handling rollouts
* replicasets -create pods, ensure replica count
* pods - does the work
* services - creates endpoints (caveats), routes traffic
* endpoints - ip/port details for workloads behind service

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

Knowing the basics can go a long way towards quickly resolving issues in a k8s cluster

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

## Why Workloads Fail 

* Pods fail to get scheduled or becoming "ready"
* Services fail to route traffic
* Application errors

<!--

Three major areas for workload failure in k8s

Being able to quickly identify _where_ a failure is happening can be difficult.
-->
---

## Failing Pods

![bg](./assets/rusty-bucket.jpeg)

<!-- 

Links:

* https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application-introspection/
* https://kubernetes.io/docs/tasks/debug-application-cluster/debug-pod-replication-controller/

-->

---

### `Pending` Pods

> PENDING means that it can not be scheduled onto a node.

Setup:

`kubectl apply -f manifests/1-node-exhausted.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe pods/$(first-pod)`

<!--

NOTE: Im using the alias `first-pod` to insert the POD NAME.

Using GET with multiple resource types, we can see the deployment and replica set were
create, but the pod is PENDING.

Lets look at the details of the pod.

NEXT

-->

---

### `Pending` Pods :: Insufficient Node Resources

`kubectl describe pods/$(first-pod)`:
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

NEXT

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

When debugging k8s resources remember the layers of abstraction is important.

Here we dont have any pods... so the issue must be a layer up.

Lets describe the replica set.

-->

---

### `NO` Pods!? :: Resource Quotas

`kubectl describe replicasets/RS_NAME_HERE`:
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

We exceeding a CPU quota applied to our namespace. 

Examining the YAML file you'll see a resource quota was applied.

Maximum total CPU request size for all containers CPU is 50m, but we requested 500m.

SHOW, DESCRIBE QUOTAS

That quota is probably too low.

Many other issues causing PENDING pods including:

* Taints & affinities
* PENDING PVCs
* Scheduler or kubelet errors 

-->

---

### Scheduled, not `RUNNING`

Setup:

`kubectl apply -f manifests/3-crashing-app.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe pods/$(first-pod)`
* `kubectl logs $(first-pod)`

```
spotty-5bbb8dbf54-9mvfr   0/1     CrashLoopBackOff   4          2m35s
```

<!--
Here we can see that a pod is getting scheduled, but its failing to RUN.

Lets describe the pods details.
-->

---

### Scheduled, not `RUNNING` :: Application Error

<!--
Looking at the DESCRIBE output we can see a few things:

* It was scheduled to a node
* The container is terminated due to an exit code of one
* There is a BackOff event happening because the container is failing repeatedly

Lets see if we can get some container logs
-->

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
---

### Scheduled, not `RUNNING` :: Getting Logs

Tools:
* `kubectl logs $(first-pod)`
* `kubectl logs $(first-pod) --previous`
* `kubectl logs $(first-pod) -c CONTAINER_NAME`
* `kubectl logs $(first-pod) --all-containers=true`

```
Starting server on :8080
Something janky happened!
```

<!--
Sometime containers fail so fast they dont log any details.

use the --previous flag to pull logs from a previous container that failed in the Crash back off loop.

We can see that "something janky" happened. This is actually a flag to the binary that I added to cause the app to crash for demonstration purposes. Lets remove that flag.

Other issues causing CrashLoopBackOff

* Wrong docker command
* Application errors
* Bad livenessprobe

Links:
* https://kubernetes.io/docs/tasks/debug-application-cluster/determine-reason-pod-failure/
  
-->

---

### Images Fail to Pull

Setup:

`kubectl apply -f manifests/4-bad-image.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe pods/$(first-pod)`

---

<!--
Here we can clearly see there is an error fetching the image.

You might see ErrImagePull or ImagePullBackOff depending on how many failures have occurred.

In this case, if we look at the YAML we can see the docker image tag is "lol." Thats not a real tag.

* Invalid docker repo credentials (ImagePullSecrets)
* Bad image name or label
* Docker rate limiting :D
-->

### Images Fail to Pull :: Image Not Found

`kubectl describe pods/$(first-pod)`:
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

### Pods is `RUNNING`, but not `READY`

`RUNNING` the container's entrypoint/command started
`READY` it can accept traffic

Setup:

`kubectl apply -f manifests/5-not-ready.yaml`

Tools:

* `kubectl get deployments,replicasets,pods`
* `kubectl describe pods/$(first-pod)`
* `kubectl logs $(first-pod)`

<!--

RUNNING vs READY

* A pod with no readiness probe is READY by default once RUNNING
* If a readiness probe is defined, the pod will get into RUNNING, then once the probe passes it will be come READY for traffic

SHOW, DESCRIBE READINESS PROBE

-->

---

<!--

When we get the pod we can see that the status is running but 0/1 of the containers in the pod are ready... 

If we look at the logs we can see some 500 errors/

YMMV: If we look at the YAML we'll see a readiness probe configured. The URL path "/spotty" returns errors 80% of the time.

-->

### Pods is `RUNNING`, but not `READY` :: Logs

`kubectl get pods`:
```
NAME                          READY   STATUS    RESTARTS   AGE
pod/spotty-76c5c5874f-b4jtq   0/1     Running   0          6s
```

`kubectl log $(first-pod)`:
```
Starting server on :8080
[GET] 500 /spotty
[GET] 500 /spotty
[GET] 200 /spotty
```

---

### Pods is `RUNNING`, but not `READY` :: Readiness

<!--

If we describe the pod, we can see a number of important details:

* We can see the state is RUNNING and the started time
* We can see the details of the readiness probe
* We can see the Condition READY is False
* We can see Unhealthy warnings in the event log

Kubernetes will not send traffic to this pod while its unhealthy!

Lets fix that!
-->

`kubectl describe pods/$(first-pod)`

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

### Port forwarding a `READY` pod 

<!--

Traffic isn't routing correctly to the pod 

Port-forwarding directly to a pod can help rule out an issue with that pod.

The left port number is a number on your machine, the right is the port of the pod.

After forwarding, you should be able to browse to localhost and see your app.

If port forwarding fails you'll see "connection refused" or a similar message in your console. 

Generally if an app is READY but the port cannot be forwarded it means the app is listening on the wrong port or IP

-->

Setup:

`kubectl apply -f manifests/6-one-fine-app.yaml`

Tools:

* `kubectl port-forward pod/$(first-pod) 8080:8080`
  
When port-forwarding fails:
* the app is listening on a different port than you forwarded
* the app is listening on an IP address besides `0.0.0.0`
---

## Failing Services

![bg](./assets/bad-day.jpeg)

---

<!--

Links:
* https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

-->

### Service Fails to Route

Setup:

`kubectl apply -f manifests/7-no-endpoints.yaml`

Tools:

* `kubectl get svc`
* `kubectl describe svc/spotty`

<!--

Its important to remember kubernetes is abstrations all the way down

A service is an abstraction over endpoints, applications bound to IP/ports

Services find applications using label selectors

Empowers you to do canaries, blue/green, and deployment rollovers - because one service can target MULTIPLE versions of a deployment
-->
---

<!--

Describe the service, 

Can't find any endpoints to route traffic to

Usually this indicates a problem with the pods or with _finding_ the pods

SHOW AND DESCRIBE service

-->

### Service Fails to Route :: Wrong Label Selector

`kubectl describe svc/spotty`
```
Name:                     spotty
Namespace:                default
Selector:                 app=spottie
Type:                     NodePort
IP:                       10.102.252.253
Port:                     <unset>  8080/TCP
TargetPort:               web/TCP
NodePort:                 <unset>  32459/TCP
Endpoints:                <none>
```

---

### Service Fails to Route :: Wrong Label Selector

<!--

If we look at the YAML and see what labels the service is targeting, we can use those labels to pull up the pods.

Using S P O T T I E, we get nothing. 

GET all the pods and their labels.

Service's label selector was spelled wrong.

If the label selector had been correct, we would want to check our pod to make sure it was getting an IP address assigned.

-->


`kubectl get pods --selector=name=spottie`:
```
No resources found in default namespace.
```

`kubectl get pods -o jsonpath='{.items[*].metadata.labels}'`:

```
{"app":"spotty","pod-template-hash":"75f4475fff"}
```

---

### Service Fails to Route


Setup:

`kubectl apply -f manifests/8-target-locked.yaml`

Tools:

* `kubectl describe svc/spotty`

<!--

Lets fix our bad label selector.

Run describe, we can now see the endpoints.

-->
---

### Service Fails to Route :: Bad Target

<!--

SIDE NOTE: 

* Services are "internal" load balancers in kubernetes. Depending on the cloud provider and service type an external load balancer may be created.

* With docker for desktop, that is not the case, we have to port-forward the service to access it, but always remember that you can port forward a service OR a pod. 

* Its very helpful in diagnosing which component is experiencing the problem.


FORWARD the service's port and access the app - but its doesnt load.

In the command above the left port is the port on your machine, the right port is the port of the pod or the service.

In the output the right side of the arrow is the targetPort of the workload. We can see it is trying to reach 8081.

LOOK AT YAML manifest, we can see spotty runs on 8080, someone typed the wrong port number :(
-->

`kubectl port-forward svc/spotty 8080:8080`:

```
Forwarding from 127.0.0.1:8080 -> 8081
Forwarding from [::1]:8080 -> 8081
Handling connection for 8080
Handling connection for 8080
E0615 10:07:05.769871   51714 portforward.go:400] an error occurred forwarding 8080 -> 8081: 
  error forwarding port 8081
```

---

### Port Forwarding a Service

Setup:

`kubectl apply -f manifests/9-one-fine-svc.yaml`

Tools:

* `kubectl describe svc/spotty`
* `kubectl port-forward svc/spotty 8080:8080`

---

### Port Forwarding a Service :: Whats in a Name?

<!--
SHOW YAML explain the TargetPort is called "web" instead of 8081.

Kubernetes supports "naming" ports and referencing them by name, this has two advantages:

* if the application developer changes their port, the service still works
* if the service operator MISSPELLS the name, endpoints won't bind
* This can be helpful in diagnosing issues, because a wrong port number WILL give you an endpoint, giving you a false positive that everything is configured correctly.
-->

`kubectl describe svc/spotty`:

```
Name:                     spotty
Namespace:                default
Selector:                 app=spotty
Type:                     NodePort
IP:                       10.102.252.253
Port:                     <unset>  8080/TCP
TargetPort:               web/TCP
NodePort:                 <unset>  32459/TCP
Endpoints:                10.1.1.125:8080
External Traffic Policy:  Cluster
```

---

<!--

Links:
* https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/
* https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/
* https://kubernetes.io/docs/tasks/debug-application-cluster/local-debugging/
  
-->

## Debugging Workloads

Setup:

`kubectl apply -f manifests/10-app.yaml`

Tools:

* `kubectl exec pod/$(first-pod) -it -- sh`
* `kubectl debug`

---

## Debugging Workloads :: Exec into Container

`kubectl exec pod/$(first-pod) -it -- sh`:

```
/ # ls
bin            etc            proc           spotty-server  var
boot           home           root           sys
busybox        lib            run            tmp
dev            lib64          sbin           usr

/ # ps
PID   USER     TIME  COMMAND
    1 1000      0:00 /spotty-server
   12 1000      0:00 sh
   18 1000      0:00 ps
```

<!--

kubectl exec puts you into the running pod/container. You can see from the `ps` output that spotty-server is running as non-root PID 1

-->

---

## Debugging Workloads :: Kubectl Debug

<!-- 

In practice, you may not be able to shell into a container. Some containers purposefully dont have shells for security reasons.

kubectl debug allows you to create copies of existing pods and all of their configuration, but change the base image.
-->

Create a copy of the pod with a new image:
```
kubectl debug $(first-pod) -it --copy-to=dbg-spotty \
  --set-image=spotty=coryodaniel/spotty-server:latest-debug
```

```
kubectl delete pod/dbg-spotty
```

---
## Debugging Workloads :: Kubectl Debug

<!--

Other times you may need some debugging tools that aren't built into your container.

kubectl debug can inject other containers into the pod copy.

Unsupported in docker for desktop is the idea of ephemeral containers. This allows you to instead of copying the pod, to inject containers into the RUNNING pod. You can even inspect other pods' processes
-->

Copy the pod, set new image, add an additional busybox container for debugging
```
kubectl debug $(first-pod) -it --copy-to=dbg-spotty-bb --image=busybox \
  --set-image=spotty=coryodaniel/spotty-server:latest-debug
```

---
## Thanks!