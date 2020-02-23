theme: work, 3

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
# Kubernetes
# [fit] Better Together?

![original](images/amorgos-greece.jpg)

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

^ K8s and the BEAM are very different systems, so its a little odd to compare.

^ But you can see there are a lot of areas where the BEAM doesnt have an out of the box solution

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

^ And so, we come back to this question.

^ Bad news, I'm not going to answer this for you.

^ I'm hoping to help _you_ answer it.

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

^ Do you have an Ops team?

^ No, can your business sacrifice developer time to learn k8s?

^ Could you reliabily run on Heroku, Zeit, Fargate, or Gigalixer?

^ My motto when approaching new projects is: Bring your experience, not your solutions.

^ Im familiar with the benefits Kubernetes brings and I use Kubernetes for all of my local development, but its certainly not a need.

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

^ not home grown complexity

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
- Load Balancers, DNS Records, Health Checks, Access Control, _Billy Joel_
- Ports, Firewalls, IAM
- Do I need a _sErvIce MeSH?!1!_

---

[.build-lists: true]
![right](images/not-so-cute-octopus.jpg)

# [fit] **WHEW!**

That's a lot of tooling.

^ Lots of things to cobble together

^ A lot of tools to be an expert in

^ Lots of things to know how to handle when things go wrong

---

# Aarggh! <br/><br/>Our VMs are only using <br/>**8.3%** <br/>of their CPU.

![right](images/not-so-cute-octopus.jpg)

^ Ok, lets go create a new Launch Config, assign it to our ASG, roll out new instances, and terminate the old ones.

^ Not only do we build a lot of complexity into our apps, we build a lot of complexity in to our deployment, ci/cd, and our infrastructure

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
# [fit] **Learned** Complexity

<!-- ^ Do you need Kubernetes? No. Do you need a unified tool for managing cloud resources and workloads lifecycles? Probably. -->

^ A single tool (and API) to manage: workloads, load balancers, service discovery entries, dns records, metrics systems, databases, buckets.

^ Logging, metrics, and alerting all via the same API.

^ And while we are about to look at some technical Kubernetes features, I would argue the best two features of Kubernetes are the API and the learned complexity that can be reused from project-to-project.

---

^ I have a prediction.

> In the next few years the Kubernetes API will become the common API for interfacing with cloud resources.

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

^ GCP released Config Connector, which in typical cloud provider fashion has a name that means absolutely nothing, but it allows any GCP resource to be managed by the Kubernetes API.

^ I'm sure it'll be only weeks before the deprecate it, but in the meantime

^ I can manage all of my resources on GCP with kubectl. 

^ No need for DeploymentManager, Terraform, or gcloud CLI

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
# [fit] Expose 
# [fit] Continuous
# [fit] Deployment

^ A lot of useful features, but if your org isn't ready, start with something simpler. Get a solid CI/CD deployment in place and migrate to kubernetes without your application developers ever noticing.

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
# [fit] No
# [fit] It 
# [fit] Doesn't

---

[.text: alignment(center)]

# [fit] A **"declarative"** interface

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

^ Now, I love YAML, but in the wise words of Duke Ellington.

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

> F*ck, that noise.
-- Duke Ellington

---

# [fit] Ops wants 
# [fit] **Kubernetes**
# [fit] Devs want
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

# [fit] So...
# [fit] **BEAM and Kubernetes:**
# [fit] Better Together?

^ let's talk about what we are here for.

---

^ Lightning Round.

^ A quick glance at the feature list from earlier and we can see that Kubernetes can add to your applications availability

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

<!--

---

# But first, Lets talk 9's

^ Downside of using Kubernetes API for managing cloud resources

^ If you are chasing the 9 9's in the sky, there are some SLAs to reckon with.

^ Note, this is the Kubernetes API SLAs, assuming instance SLAs would impact apps on or off Kubernetes.

| Cloud              | Availability | Backing |
| ------------------ | ------------ | ------- |
| Azure AKS          | 99.5%        | :x:     |
| AWS EKS            | 99.9%        | credits |
| GCP GKE (regional) | 99.95%       | :x:     |
| GCP GKE (zonal)    | 99.5%        | :x:     |
-->

---

# Thanks
