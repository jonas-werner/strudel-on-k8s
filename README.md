# Strudel Helm Chart

This Helm chart deploys the Strudel live coding web application along with Prometheus and Grafana for metrics collection and visualization.

## Chart contents 

The chart will deploy the Strudel app as well as a custom metrics exporter, Prometheus and Grafana. 

```
├── Chart.yaml
├── grafana-dashboard.json
├── README.md
├── templates
│   ├── _helpers.tpl
│   ├── grafana-dashboard-provider.yaml
│   ├── grafana-datasources.yaml
│   ├── grafana-ingress.yaml
│   ├── grafana-secret.yaml
│   ├── grafana.yaml
│   ├── ingress.yaml
│   ├── metrics-server.yaml
│   ├── prometheus.yaml
│   └── strudel-deployment.yaml
└── values.yaml
```

## Resource Summary

This chart creates the following Kubernetes resources:

- **ConfigMaps**: 4
  - Grafana dashboard provider (`grafana-dashboard-provider.yaml`)
  - Grafana datasources (`grafana-datasources.yaml`)
  - Grafana dashboard (`grafana.yaml`)
  - Prometheus configuration (`prometheus.yaml`)

- **Ingress**: 2
  - Strudel application ingress (`ingress.yaml`)
  - Grafana ingress (`grafana-ingress.yaml`)

- **Deployments**: 4
  - Strudel application (`strudel-deployment.yaml`)
  - Grafana (`grafana.yaml`)
  - Prometheus (`prometheus.yaml`)
  - Metrics server (`metrics-server.yaml`)

- **Secrets**: 1
  - Grafana admin credentials (`grafana-secret.yaml`)

- **Helper Templates**: 6
  - `strudel.name` - Chart name helper
  - `strudel.fullname` - Fully qualified app name helper
  - `strudel.chart` - Chart name and version helper
  - `strudel.labels` - Common labels helper
  - `strudel.selectorLabels` - Selector labels helper
  - `strudel.coreweaveHostname` - CoreWeave hostname builder helper

## Accessing Services

### Strudel Application

The Strudel application is accessible via the ingress endpoint:

```
https://strudel.{orgID}-{clusterName}.coreweave.app
```

Replace `{orgID}` and `{clusterName}` with the values configured in your deployment (set via ArgoCD parameters or values file).

### Grafana

Grafana is accessible via the ingress endpoint:

```
https://grafana.{orgID}-{clusterName}.coreweave.app
```

**Login Credentials:**
- **Username**: `admin`
- **Password**: Retrieve the password using the following command:

```bash
kubectl get secret strudel-<cluster-name>-grafana -n <namespace> -o jsonpath='{.data.admin-password}' | base64 -d
```

For example, if your cluster name is `new-cluster` and namespace is `strudel` (default):

```bash
kubectl get secret strudel-new-cluster-grafana -n strudel -o jsonpath='{.data.admin-password}' | base64 -d
```

The secret name follows the pattern `{release-name}-grafana` where `{release-name}` is the Helm release name used during deployment.

## Using Strudel

Making original songs with Strudel is a bit time consuming, but several good libraries of sample songs are available. For example: [Strudel-songs-collection by Eefano](https://github.com/eefano/strudel-songs-collection/tree/main). Just copy and paste in the code and hit play. 
