# Logical CPUs, Beam Schedulers, Kubernetes, and cgroups

Examine the effect of using Kubernetes resource requests/limits on BEAM
applications setting their schedulers to the number of logical CPUs.

## Experiments

1. Set QoS guaranteed 1 vCPU, on 64 CPU machine.
2. Set QoS guaranteed 1 vCPU, on 64 CPU machine, set online schedulers to 1

**Measure:**

Start N(?) prime calculators

* Calculation time
* Measure context switching

