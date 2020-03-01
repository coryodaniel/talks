theme: work, 3
quote: #f1be52, Helvetica
quote-author: #fff, "Work Sans"

<!-- # [fit] BEAM and Kubernetes: 
# [fit] Better Together? -->

# <br />
# <br />
# <br />
# <br />
# <br />
# <br />
# <br />
# BEAM
# and
# Kubernetes:
# [fit] Better Together?

![original](images/amorgos-greece.jpg)

^ I'm here to guide you through the stormy seas of Kubernetes.

---

# Cory O'Daniel

- Maintainer: Bonny, k8s.ex, Arbor
- Twitter: @coryodaniel
- GitHub: @coryodaniel

Pronounces kubectl: _kube cuddle_ or _kube cartel_ depending on my mood.

![right](./images/bonny-banner.png)

^ I'm _onboard_ with Kubernetes.

^ The only thing I love more than mispronouncing kubectl is YAML

---

![fit](./images/yaml_af.png)

^ Seriously, I love it. _BUT_ I fell down a staircase as a kid, so YMMV.

---

# [fit] Are they 
# [fit] **better**
# [fit] together?

^ So, what you're here for, right?

---

^ Don't get hung up on these tables, we are coming back to them later

^ Kubernetes offers a lot of features that may really float your boat.

^ These are just the marketing page features. 

^ On the right are the related components of Kubernetes

| Features                                  | Kubernetes                                            |
| ----------------------------------------- | :---------------------------------------------------- |
| Automated Rollouts / Rollbacks            | `Deployment`, `ReplicaSet`, `StatefulSet`             |
| Automated Scheduling (instance placement) | pod/node affinity/anti-affinity, `resources`          |
| Bin Packing                               | `Policy`, `LimitRange`, `resources`                   |
| Batch Jobs / Execution                    | `Job`, `CronJob`                                      |
| Service Discovery / DNS                   | `Service`, `Endpoint`, `EndpointSlices`, external-dns |
| Load Balancing                            | internal & external load balancers                    |
| Storage Orchaestration                    | `PersistentVolume`, `StorageClass`, and CSI           |
| Secret "Management"                       | `Secret`                                              |
| Config Management                         | `ConfigMap`                                           |
| Health Checks                             | Shell, TCP, and HTTP Health Checks                    |
| Horizontal Scaling                        | `HorizontalPodAutoscaler`                             |
| Vertical Scaling                          | `VerticalPodAutoscaler`, `resources`                  |
| QoS                                       | `PodDisruptionBudget`, `resources`                    |
| Security Templates                        | `PodSecurityPolicy`, `securityContext`                |
| Metrics                                   | metric-server, custom-metrics-server                  |

---

^ When we look at the features that the BEAM lacks here, we can see that Kubernetes can really put the wind in your sails.

^ So the easy aanswer is of course: <consultant hat>, yes, they are better together

^ but...

| Feature                                   | Kubernetes                                            |              Beam or Erlang/OTP              |
| ----------------------------------------- | :---------------------------------------------------- | :------------------------------------------: |
| Automated Rollouts / Rollbacks            | `Deployment`, `ReplicaSet`, `StatefulSet`             |               Hot Code Loading               |
| Automated Scheduling (instance placement) | pod/node affinity/anti-affinity, `resources`          |                      -                       |
| Bin Packing                               | `Policy`, `LimitRange`, `resources`                   |                      -                       |
| Batch Jobs / Execution                    | `Job`, `CronJob`                                      |                  Processes                   |
| Service Discovery / DNS                   | `Service`, `Endpoint`, `EndpointSlices`, external-dns |                      -                       |
| Load Balancing                            | internal & external load balancers                    |                      -                       |
| Storage Orchaestration                    | `PersistentVolume`, `StorageClass`, and CSI           |                      -                       |
| Secret "Management"                       | `Secret`                                              |                      -                       |
| Config Management                         | `ConfigMap`                                           |             vm.args, sys.config              |
| Health Checks                             | Shell, TCP, HTTP Health Checks                        |            Supervisors, `-heart`             |
| Horizontal Scaling                        | `HorizontalPodAutoscaler`                             |             Add nodes :thumbsup:             |
| Vertical Scaling                          | `VerticalPodAutoscaler`, `resources`                  |          Add CPUs / RAM :thumbsup:           |
| QoS                                       | `PodDisruptionBudget`, `resources`                    |                      -                       |
| Security Templates                        | `PodSecurityPolicy`, `securityContext`                |                      -                       |
| Metrics                                   | metric-server, custom-metrics-server                  | `erlang:system_info/1` `erlang:statistics/1` |

---

# [fit] Are they 
# [fit] **better**
# [fit] together?

^ When asking this question, we've already made an assumption that we haven't vetted.

^ Raise your hand if your company is using kubernetes, keep it up

^ if your ops team abstracts away kubernetes via CI/CD, put your hand down

^ Ok, now if you are on the ops or SRE team, put your hand down

^ So everyone with their hand up is an application developer that interfaces with Kubernetes directly.

^ Ok, put your hand down if you like Kubernetes

^ So the people with your hands up, I feel your pain.

^ By asking this question, we are making an assumption and there is a better question to start with

---

[.header: alignment(center)]

# [fit] **YOUR_ORG** and Kubernetes: Better Together?

![inline](images/office-space.png)

^ _your organization_ and Kubernetes: Better Together?

^ **3 MINUTES**

---

# [fit] Your Startup's 
# [fit] **MVP** 
# [fit] On Kubernetes:

![right fit](images/startup-mvp-on-k8s.jpeg)

^ This may be funny... until you realized this is barely an exageration.

---

# [fit] Your Startup's 
# [fit] **MVP** 
# [fit] On Kubernetes:

![right](images/a-real-bitch.jpeg)

^ Before rolling k8s out in an organization, I ask a few questions:

^ [Pause] Actually I ask a lot of questions, but these are the high notes

^ Do you have an Ops team?

^ No, can your business sacrifice developer time to learn k8s? These are people that are hopefully building revenue generating features.

^ Could you reliabily run on Heroku, Zeit, Fargate, or Gigalixer?

^ My motto when approaching new projects is: Bring your experience, not your solutions.

^ Im familiar with the benefits Kubernetes brings and I use Kubernetes for all of my local development, but its certainly not a need.

^ **4:30 MINUTES**

---

[.build-lists: true]

# Kubernetes Best Features

^ The three best kubernetes features werent in those tables. 

^ You wont find them on the marketing or landing pages.

^ And you probably won't find them in books.

* A simple, _extendable_ API and client
* Learned Complexity
* Community

^ Kubernetes REST API, CRDs, and kubectl

^ Learned Complexity is a feature, home grown complexity is debt

^ 100s of companies have contributed to k8s in the last year including: Apple, Amazon, Red Hat, Google, VM Ware, Spotify, Tesla

---

^ If you were pitching Kubernetes to your team, every single feature in this list could be rebutted with something "simpler."

| Features                                  | Kubernetes                                            |
| :---------------------------------------- | :---------------------------------------------------- |
| Automated Rollouts / Rollbacks            | `Deployment`, `ReplicaSet`, `StatefulSet`             |
| Automated Scheduling (instance placement) | pod/node affinity/anti-affinity, `resources`          |
| Bin Packing                               | `Policy`, `LimitRange`, `resources`                   |
| Batch Jobs / Execution                    | `Job`, `CronJob`                                      |
| Service Discovery / DNS                   | `Service`, `Endpoint`, `EndpointSlices`, external-dns |
| Load Balancing                            | internal & external load balancers                    |
| Storage Orchaestration                    | `PersistentVolume`, `StorageClass`, and CSI           |
| Secret "Management"                       | `Secret`                                              |
| Config Management                         | `ConfigMap`                                           |
| Health Checks                             | Shell, TCP, and HTTP Health Checks                    |
| Horizontal Scaling                        | `HorizontalPodAutoscaler`                             |
| Vertical Scaling                          | `VerticalPodAutoscaler`, `resources`                  |
| QoS                                       | `PodDisruptionBudget`, `resources`                    |
| Security Templates                        | `PodSecurityPolicy`, `securityContext`                |
| Metrics                                   | metric-server, custom-metrics-server                  |

---
# Kubernetes Best Features

^ These features here, aren't offered by a single cloud provider.

^ So lets look at these features.

* A simple, _extendable_ API and client
* Learned Complexity
* Community

---

# [fit] Apps start out
# [fit] **so cute**...

![right](images/cute-octopus.jpg)

^ They start out so cute.

^ We've got a simple monolith. 100% Coverage, Deploying with SSH.

---

[.build-lists: true]
![right](images/not-so-cute-octopus.jpg)

^ The next thing you know, you've outgrown your PaaS, your VM, or maybe your tooling...

^ Brittle deployments, bespoke bash scripts, bending over backwards to make things work

^ Maybe you are already on 'the cloud' or are start to consider a migration

- _Packer_ for VM Images
- _Terraform_ for VM Instances
- _Salt_ or _Chef_ for Configuration
- _KMS_ for Secrets
- Deployin' with _bash_
- _LOL_ for rollbacks
- _Terraform_ or _aws-cli_ for Autoscaling Groups
- Load Balancers, DNS Records, Health Checks, Access Control
- Ports, Firewalls, IAM
- Do I need a _sErvIce MeSH?!1!_

---

[.build-lists: true]
![right](images/not-so-cute-octopus.jpg)

# [fit] **WHEW!**

That's a lot of tooling.

^ WHEW

^ Someone should mash that last slide up with "We Didnt Start Fire"

^ Lots of things to cobble together

^ A lot of tools to be an expert in

^ Lots of things to know how to handle when things go wrong

---

# Aarggh! <br/><br/>Our VMs are only using <br/>**8.3%** <br/>of their CPU.

![right](images/not-so-cute-octopus.jpg)

^ Ok, lets go create a new Launch Config, assign it to our ASG, roll out new instances, and terminate the old ones.

^ Not only are we building more complex applications, we are building more complex operations.

^ **7:30 MINUTES**

---

^ At some point we need to consider the operational complexity _we_ are creating.

# What business value are you **creating** by reinventing the ~~wheel~~ <br/>helm?

![right](images/not-so-cute-octopus.jpg)

---
[.text: alignment(center)]

# [fit] Kubernetes
# is
# [fit] **Complicated**

^ Ok, Cory, sure we are creating complexity, but Kubernetes is COMPLICATED TOO

^ High barrier to entry; 
* That should be an Operational Burden 
* Partially relieved by EKS/GKE

---
[.text: alignment(center)]

# [fit] Kubernetes
# is
# [fit] ~~Complicated~~ 
# [fit] **Learned Complexity**

<!-- ^ Do you need Kubernetes? No. Do you need a unified tool for managing cloud resources and workloads lifecycles? Probably. -->

^ A single tool (and API) to manage: workloads, load balancers, service discovery entries, dns records, metrics systems, databases, buckets.

^ Logging, metrics, and alerting all via the same API.

^ And while we are about to look at some technical Kubernetes features, I would argue that these two features (API & Learned Complexity) are what you come to Kubernetes for.

^ Learned complexity that you can take from job-to-job, project-to-project, and cloud-to-cloud.

^ **8:30 MINUTES**

---

^ I have a prediction.

> In the next few years, the Kubernetes API will become the common API for interfacing with cloud resources.

^ I'm going to say it again just in case someone wants to record a video to call me out in three years.

^ That may sound crazy, but...

---
[.build-lists: true]
# What can you deploy today?

* Workloads
* Batch jobs
* Load balancers
* DNS records
* Machine learning models and pipelines (kubeflow)
* DynamoDB Tables, S3 buckets, BigQuery Tables

^ AWS had released the service operator (SNS, SQS, Memcached, Redis)

^ GCP released Config Connector, it allows any GCP resource to be managed by the Kubernetes API.

^ Its Google, so they could deprecate it any moment, 
but in the meantime I can manage all of my resources on GCP with kubectl. 

^ There is still some work here to do on these tools, but its plausible that one day there won't be need for DeploymentManager, Terraform, or gcloud CLI

---
[.text: alignment(center)]

# [fit] The CNCF and Kubernetes Community

![inline](./images/cncf-landscape.png)

^ the third most important feature

[.footer: Source: [CNCF Cloud Native Interactive Landscape](https://landscape.cncf.io/)]

---
[.text: alignment(center)]

# [fit] HOLY
# [fit] :poop:!!!

---

# [fit] The CNCF and Kubernetes Community

![inline](./images/cncf-landscape-k8s.png)

^ Most of the stuff on this page is open-source projects. The stuff circled in red are companies invested in the Kubernetes ecosystem.

[.footer: Source: [CNCF Cloud Native Interactive Landscape](https://landscape.cncf.io/)]

---

[.build-lists: true]

# Recap:
# What to pitch people 
# on when **considering Kubernetes**

* A simple, _extendable_ API and client
* Learned Complexity
* Community

---

# [fit] The risk 
# of 
# [fit] Kubernetes

![](./images/leaky-boat.jpg)

^ I know "Unpopular Opinions" are popular on twitter, but how do y'all feel about incendiary opinions?

^ The biggest risk when deploying kubernetes is a leaky abstration that requires your application developers to become intimately familiar with k8s.

^ Everyone that was still standing early, has been exposerd to this risk.

^ DevOps is a practice to make operations better, not another role you toss on your full stack developers.

^ If your application developers are doing "devops", they spending less time building business value.

---

# [fit] Don't Expose Kubernetes to Developers
# [fit] Use 
# [fit] **Continuous**
# [fit] **Delivery**

^ When deploying kubernetes (read slide)

^ Having a good CI/CD pipeline in place first, will make for a smoother Kubernetes migration.

[.footer: Don't be a gatekeeper, though, curiousity drives innovation.]

---

# [fit] Leaky Abstraction?!
# <br/>
# [fit] Kubernetes Has A 
# [fit] Simple, **Declarative** 
# [fit] Interface!!1!

^ You might be thinking...

---

# Spoiler Alert:
# [fit] **No**
# [fit] It 
# [fit] Doesn't

---

# Spoiler Alert:
# [fit] No
# [fit] **It** 
# [fit] Doesn't

---

# Spoiler Alert:
# [fit] No
# [fit] It 
# [fit] **Doesn't**

---

[.text: alignment(center)]

# [fit] A **"declarative"** interface

^ Kubernetes has a (AIR QUOTES) declarative interface

> One person's declarative is another person's imperative
> -- me

---

[.code-highlight: all]

^ You can't read that can you? Let me reassure you, it's "declarative."

[.code-highlight: 1-2]

^ Ok, not so bad, I got this.

[.code-highlight: 3-5, 10-12, 14-16]

^ Uh ok, thats a lot of Copy/pasta. 

[.code-highlight: 21-27]

^ Geez, I dont know, I just want my app to work, dammit.

[.code-highlight: 28-32]

^ This is an excerpt from the eviction operator YAML manifest generated by Bonny. Its about 180 lines long.

^ Now, I love YAML, but in the wise words of Johann Bach

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    k8s-app: eviction-operator
  name: eviction-operator
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: eviction-operator
  template:
    metadata:
      labels:
        k8s-app: eviction-operator
    spec:
      containers:
        - image: quay.io/coryodaniel/eviction-operator:0.1.1
          name: eviction-operator
          resources:
            limits:
              cpu: 200m
              memory: 200Mi
            requests:
              cpu: 200m
              memory: 200Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            runAsNonRoot: true
            runAsUser: 65534
      serviceAccountName: eviction-operator
```

[.footer: Excerpt from the eviction-operator manifest generated with Bonny. Originally ~180 lines.]

---

> F*ck that noise.
-- Johann Bach

---

# [fit] **Ops wants**
# [fit] **Kubernetes,**
# [fit] Devs want
# [fit] Heroku

---

# [fit] Ops wants
# [fit] Kubernetes,
# [fit] **Devs want**
# [fit] **Heroku**

^ Want to see a declarative interface for deploying an app?

---

# <br />
# <br />
# <br />
# <br />
# [fit] `git push`

^ A developers "declarative interface" `git push`

^ Put good CI/CD in place.

---

# So...
# [fit] BEAM
# [fit] and
# [fit] Kubernetes:
# [fit] **Better Together?**

^ let's talk about what we are here for.

---

^ We aren't going to hit all of these, unless y'all wanna skip lunch? No?

^ Ok, fine. There is a nodepool party on the roof at 5PM, meet me up there and we can go through the rest.

| Feature                                   | Kubernetes                                            |              Beam or Erlang/OTP              |   Can k8s Help?    |
| ----------------------------------------- | :---------------------------------------------------- | :------------------------------------------: | :----------------: |
| Automated Rollouts / Rollbacks            | `Deployment`, `ReplicaSet`, `StatefulSet`             |               Hot Code Loading               |        :x:         |
| Automated Scheduling (instance placement) | pod/node affinity/anti-affinity, `resources`          |                      -                       | :white_check_mark: |
| Bin Packing                               | `Policy`, `LimitRange`, `resources`                   |                      -                       | :white_check_mark: |
| Batch Jobs / Execution                    | `Job`, `CronJob`                                      |                  Processes                   | :white_check_mark: |
| Service Discovery / DNS                   | `Service`, `Endpoint`, `EndpointSlices`, external-dns |                      -                       | :white_check_mark: |
| Load Balancing                            | internal & external load balancers                    |                      -                       | :white_check_mark: |
| Storage Orchaestration                    | `PersistentVolume`, `StorageClass`, and CSI           |                      -                       | :white_check_mark: |
| Secret "Management"                       | `Secret`                                              |                      -                       | :white_check_mark: |
| Config Management                         | `ConfigMap`                                           |             vm.args, sys.config              | :white_check_mark: |
| Health Checks                             | Shell, TCP, HTTP Health Checks                        |            Supervisors, `-heart`             | :white_check_mark: |
| Horizontal Scaling                        | `HorizontalPodAutoscaler`                             |             Add nodes :thumbsup:             | :white_check_mark: |
| Vertical Scaling                          | `VerticalPodAutoscaler`, `resources`                  |          Add CPUs / RAM :thumbsup:           | :white_check_mark: |
| QoS                                       | `PodDisruptionBudget`, `resources`                    |                      -                       | :white_check_mark: |
| Security Templates                        | `PodSecurityPolicy`, `securityContext`                |                      -                       | :white_check_mark: |
| Metrics                                   | metric-server, custom-metrics-server                  | `erlang:system_info/1` `erlang:statistics/1` | :white_check_mark: |

---

^ We are going to hit all of these though.

| Feature                                   | Kubernetes                                            |    Beam or Erlang/OTP     |   Can k8s Help?    |
| ----------------------------------------- | :---------------------------------------------------- | :-----------------------: | :----------------: |
| Automated Rollouts / Rollbacks            | `Deployment`, `ReplicaSet`, `StatefulSet`             |     Hot Code Loading      |        :x:         |
| Automated Scheduling (instance placement) | pod/node affinity/anti-affinity, `resources`          |             -             | :white_check_mark: |
| Service Discovery / DNS                   | `Service`, `Endpoint`, `EndpointSlices`, external-dns |             -             | :white_check_mark: |
| Health Checks                             | Shell, TCP, HTTP Health Checks                        |   Supervisors, `-heart`   | :white_check_mark: |
| Horizontal Scaling                        | `HorizontalPodAutoscaler`                             |   Add nodes :thumbsup:    | :white_check_mark: |
| Vertical Scaling                          | `VerticalPodAutoscaler`, `resources`                  | Add CPUs / RAM :thumbsup: | :white_check_mark: |
| QoS                                       | `PodDisruptionBudget`, `resources`                    |             -             | :white_check_mark: |
| Security Templates                        | `PodSecurityPolicy`, `securityContext`                |             -             | :white_check_mark: |

---

# Deployments
[.code-highlight: all]
[.code-highlight: 11]

^ So, if you've seen a Kubernet (singular form of k8s) before, you've definitely worked with Deployments. 

^ If not, as the name suggests... its an application deployment.

^ We saw one earlier w/ the eviction operator example, but here is another brief deployment

^ This is pretty basic. It deploys 3 instances of an application `better_together`

^ Before we get into some of the more interesting kubernetes resources, 
I wanted to talk about a few attributes of Deployments that can make your applications more resilient.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: better-together
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: better-together
          image: quay.io/coryodaniel/better_together:latest
          # BestEffort :shrug-fest:
```

---

# Pod Resources & QoS

[.code-highlight: 12-18]

^ Setting resources requests and limits is critical for a deployment. 
Not only do they provide a base level of resources for your application, they implicitly determine your quality of service.

^ Kubernetes "rewards" you with a better quality of service, by providing more resource consumption information.

^ Resources are set per container in a pod

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: better-together
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: better-together
          image: quay.io/coryodaniel/better_together:latest
          resources:
            limits:
              cpu: 500m
              memory: 200Mi
            requests:
              cpu: 250m
              memory: 200Mi          
```

---

# Pod Resources & QoS

^ Requests will provide you with a CPU and memory baseline

^ Limits help Kubernetes cap CPU utilization and OOM runaway RAM consumption.

^ More importantly, what you put here determines your applications quality of service with regards to scheduling and evicting pods

^ No `resources` settings results in a BestEffort quality of service. This is the shrug emoji of availability

^ Setting a memory or CPU request in at least one container lands you in `Burstable`. Kubernetes will give you the resource you requested, and allow your app to burst above when available.

```yaml
# Burstable
resources:
  # limits are optional for Burstable class
  limits:
    cpu: 500m
    memory: 200Mi
  requests:
    cpu: 250m
    memory: 200Mi   
```
---

# Pod Resources & QoS

^ `Guaranteed` QoS is only achieved by each container having resource limits and either no requests set or, by setting requests to the same value. If not present, k8s will set requests = limits.

^ If the cluster is configured with a static CPU management policy, containers can be granted exclusive rights to a CPU (cpu affinity). In this case, requests must be set as well, and cannot be fractional

^ This is really important, because if you are using helm charts, sidecars, or mutation web hooks that add containers, and they dont set QoS to guaranteed, it will lower your entire pods QoS

^ LimitRange can be used to set minimum, maximum, and default resource requests and limits for a Namespace.

```yaml
# Guaranteed
resources:
  limits:
    cpu: 500m
    memory: 200Mi
```

---

![](./images/pod-qos.png)

---

# QoS Summary

^ Scheduling

^ Guaranteed will get scheduled if there are resources and no DiskPressure

^ Burstable may get scheduled if there are resources and no DiskPressure, no _guarantee_, resources are burstable

^ BestEffort may get scheduler if there are resources and no DiskPressure or MemoryPressure

^ Eviction

^ BestEffort and Burstable over resource requests, based on priority and resource consumption

^ Guaranteed and Burstable and never evicted when below resource requests for another pod

^ DiskPressure causes BestEffort -> Burstable -> Guaranteed eviction

|            Requests             | Limits  | Class      |    CPU Affinity    |
| :-----------------------------: | :-----: | :--------- | :----------------: |
|              none               |  none   | BestEffort |        :x:         |
|             present             |  none   | Burstable  |        :x:         |
|        none _or_ =limits        | present | Guaranteed |        :x:         |
| present, integer, _and_ =limits | present | Guaranteed | :white_check_mark: |

---

# Deployment Strategy

[.code-highlight: 7-11]

^ Kubenetes supports two deployment strategies, RollingUpdate and Recreate.

^ The Recreate strategy destroys and Recreates the deployment. Its much faster than 
a RollingUpdate, which makes it nice for development, but since the deployment is destroyed, can result in lower availability.

^ RollingUpdates, as the name suggests, rolls out your update slowly, replacing old pods with new ones.

^ Using a RollingUpdate has a few additional options: maxUnavailable, maxSurge (int, percent)
Default: 
* 25% max unavailable
* 25% max surge

^ Tuning these per application are really important for deployments. It effects rollout time and availability at the expense of resource consumption.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: better-together
spec:
  replicas: 3
  strategy:
    type: RollingUpdate # or Recreate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 25%
```

---

# Health Checks

^ Without defining healthchecks, Kubernetes can only make assumptions about your applications health based on resource consumption

> A pod without healthchecks is the Math Lady of Kubernetes
-- Nick Young

![inline](./images/math-lady-meme.jpg)

---

# Health Checks

^ there are two types of healthchecks, readiness, and liveness.

^ readiness probes let kubernetes know your application is ready to serve traffic

^ liveness probes let kubernetes know your app is ... alive

^ without these, kubernetes may send traffic early or assesses liveliness based on resource settings

^ httpGet, TCP, and shell execs, which allows you to call mix tasks or release commands

```yaml
readinessProbe:
  initialDelaySeconds: 5
  periodSeconds: 60
  httpGet:
    path: /health
    port: 4000
livenessProbe:
  initialDelaySeconds: 5
  periodSeconds: 60
  httpGet:
    path: /health
    port: 4000
```

---

# Pod lifecycle

^ Pod's have a start and stop lifecycle event where ad-hoc httpGet and execs can be fired.

^ preStop can be used to perform cleanup or execute tasks when a SIGTERM is received. 

^ In this example the host's name is broadcast to all other nodes to let them know its going down.

```yaml
containers:
  - name: better-together
    image: quay.io/coryodaniel/better_together:latest
    lifecycle:
      preStop:
        exec:
          command: 
            - bin/better_together
            - rpc
            - BetterTogether.notify_node_down()
```

---

# Pod Termination

[.code-highlight: 2]
[.code-highlight: 6]

^ Kuberntes will send a SIGTERM to your pods when they are being evicted. 
By default k8s will wait 30 seconds before sending a SIGKILL.

^ `terminationGracePeriodSeconds` can be set to tune the time in between events. 
This can be used to tune your application to give it proper time to shutdown cleanly

^ Note: terminationGracePeriodSeconds is set for the pod, not a container

^ The `terminationMessagePath` can be set for each container. 

```yaml
spec:
  terminationGracePeriodSeconds: 30
  containers:
    - name: better-together
      image: quay.io/coryodaniel/better_together:latest
      terminationMessagePath: "/app/erl_crash.dump"
```

---

```yaml
apiVersion: v1
kind: Pod
...
    lastState:
      terminated:
        containerID: ...
        exitCode: 1337
        finishedAt: ...
        message: |
          YOUR_CRASH_DUMP_HERE
        ...
```

^ Kubernetes will record the termination message in the pods status, which makes it easily accessible from a dashboard or monitoring application.

^ This can be used to ship an erl_crash.dump out of a pod that is crashing.

---

# Affinity

^ Affinity is a really interesting feature of kuberntes.

^ Its actually a few different features, Kubernetes supports: affinity and anti-affinity at the node and pod level.

^ Affinity lets you tell kubernetes to schedule your workloads on certain nodes or as neighbors to certain pods

^ AntiAffinity let you tell kuberntes that you don't want to be on a node or near a certain pod.

@HERE

* Node
* Pod
* Affinity
* AntiAffinity

---

# [fit] QUIRK
# [fit] **ALERT**

---

QUIRKS, fuck @here.
^ All that stuff is fine-and-dandy, but Kubernetes, Docker, and BEAM's schedulers and SMP do have some interesting quirks.

* Busy Wait
* Scheduler count vs. resource requests
* Concurrency, erlang is great at it, 

> An application can only be as fast as its slowest sequential code (and this includes the erlang VMs sequential code)
-- _Amdahl's Law_

<!--
* busywait, schedulers
  * https://elixirforum.com/t/performance-of-erlang-elixir-in-docker-kubernetes/21493/16
* Show CPU count, vs resource req/lim, vs schedulers
* bigger CPUs for erlang, becaause of erlang excels at managing system resources

- Weird 💩
  - Everything has quirks
    - vCPUs, cgroups, and schedulers
    - Busy wait issues
    - Pod CPU requests and being a good neighbor
    - CPU Affinity workloads - Where are we? BEAM VM in a container in a VM 
-->

---

# PriorityClass

---

# [fit] Service Discovery

* Service discover, DNS
* Distributing processes
* *talk* about process handoff w/ swarm

---

# [fit] Horizontal / Vertical Pod Autoscalers

---

# PodDisruptionBudget

---

# **Bonus** Security

securityContext, PodSecurityPolicy, Distroless

---

# Takeaways

Where can we go from here?

kOTP

# Thanks
