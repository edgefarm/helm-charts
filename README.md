<img width="200" alt="edgefarm logo" src="https://www.ci4rail.com/wp-content/uploads/2021/09/EdgeFarm_transparent-1.png">

[![License][License-Image]][License-Url]

[License-Url]: https://www.apache.org/licenses/LICENSE-2.0
[License-Image]: https://img.shields.io/badge/License-Apache2-blue.svg

# EdgeFarm Helm charts

In this repository you can find several Helm charts to deploy components used by EdgeFarm to a Kubernetes cluster. EdgeFarm is deployed in several disciplines, like edgefarm.core, edgefarm.network, edgefarm.applications. The corresponding Helm charts are located in the following disicplines:

## Core

- [Kubeedge](https://github.com/nats-io/k8s/tree/main/helm/charts/core/kubeedge)

## Network

## Applications

# Using EdgeFarm Helm charts

In this repo you can find the Helm 3 based [charts](https://github.com/edgefarm/helm-charts/tree/main/helm/charts) to install all components of EdgeFarm.

```sh
$ helm repo add edgefarm https://edgefarm.github.io/helm-charts/helm/charts
$ helm repo update

$ helm repo list
NAME          	URL 
edgefarm       	https://edgefarm.github.io/helm-charts/helm/charts/
```

Example installing kubeedge
```sh
$ helm install my-kubeedge edgefarm/core/kubeedge
```

# License

Unless otherwise noted, the EdgeFarm source files are distributed
under the Apache Version 2.0 license found in the LICENSE file.
