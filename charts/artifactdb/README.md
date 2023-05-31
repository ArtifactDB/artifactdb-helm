# artifactdb

![Version: 0.0.4](https://img.shields.io/badge/Version-0.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.2](https://img.shields.io/badge/AppVersion-0.0.2-informational?style=flat-square)

Chart to support generic deployment of ArtifactDB APIs

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://charts/elasticsearch-7.9.0.tgz | elasticsearch | 7.9.0 |
| file://charts/postgresql-10.3.13.tgz | postgresql | 10.3.13 |
| file://charts/rabbitmq-7.6.7.tgz | rabbitmq | 7.6.7 |
| file://charts/redis-10.7.16.tgz | redis | 10.7.16 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adb_maintainer_operator.enabled | bool | `false` | Experimental: deploys an Olympus Maintainer Operator, which takes care of model generation from schema updates, mapping upgrades, and reindexing. |
| admin.enabled | bool | `true` | Deploy an "admin" pod allowing to expose access to a Pod's terminal through a web browser. |
| admin.replicaCount | int | `0` | Unless specificaly requested, no admin pod deployed for security reasons, to avoid unnecessary exposure. |
| admin.service.port | int | `3000` |  |
| admin.service.targetPort | int | `3000` |  |
| admin.service.type | string | `"ClusterIP"` |  |
| admin.wetty.image | string | `"wettyoss/wetty"` |  |
| affinity.podAntiAffinity | object | `{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}` | Default pod anti-affinity rule, defaulting to deploying in multiple zones if available. |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| backend.readinessProbe | object | `{"enabled":false}` | Activate readiness probe, checking availability of RabbitMQ. |
| backend.replicaCount | int | `2` | Number of replicas for backend pods performing async tasks, such as indexing. |
| backend.service.port | int | `5555` |  |
| ci | bool | `false` | Specifies if the deployment is running within a CI pipeline. This adds a label `ci: true` in the deployments, that can indirectly be used to avoid exposing the REST API unintentionally (eg. with a combination of tolerations and k8s nodes labelling, highly depends on the k8s cluster setup though, ymmv...) |
| elasticsearch | object | `{"clusterHealthCheckParams":"wait_for_status=yellow&timeout=1s","enabled":false,"imageTag":"7.4.0","minimumMasterNodes":1,"replicas":1}` | For local development/test purposes, deploys a single node Elasticsearch "cluster". |
| flower.image | string | `"mher/flower:0.9.5"` |  |
| flower.replicaCount | int | `1` | Number of replicas for Flower (UI on top of RabbitMQ). 1 is enough... |
| flower.service.port | int | `8888` |  |
| flower.service.targetPort | int | `5555` |  |
| flower.service.type | string | `"ClusterIP"` |  |
| frontend.autoreload.enabled | bool | `false` |  |
| frontend.readinessProbe | object | `{"enabled":true}` | Activate readiness probe, checking availability of /status endpoint. Recommended for production. |
| frontend.replicaCount | int | `2` | Number of replicas for frontend pods serving REST API. |
| frontend.service.port | int | `8000` |  |
| frontend.service.targetPort | int | `8000` |  |
| frontend.service.type | string | `"ClusterIP"` |  |
| frontend.workers | string | `nil` | Number of gunicorn workers serving the API. `null` for unlimited where gunicorn itself sets it according to available cores. |
| fullnameOverride | string | `""` |  |
| global.env | string | `nil` | Specify the environment. Value must match a config-{env}.yml file used as a ConfigMap content. |
| global.envSecrets | string | `nil` | Optional: specify the environment name to select sealed-secret file. If not set, `global.env` is used. |
| global.instance_id | string | `"artifactdb"` | Instance ID, lowercase, no space, 16 chars max. |
| global.instance_version | string | `"v1"` | Instance version, used as a path prefix in the URL. |
| global.pythonpath | string | `"/app:/app/lib"` |  |
| global.src_folder | string | `nil` | Used for dev. environment with local Kubernetes cluster like k3d, name of the root folder containing code for that instance.  When `mountLocalCode` is used, that folder will be mounted into pods. environment. |
| global.standalone | object | `{"enabled":false,"src_path":"/app/src"}` | Runs in standalone mode, using minimal/vanilla base docker image (no customization, set to false if using a custom image). |
| image | string | `"ghcr.io/artifactdb/artifactdb-docker/artifactdb"` | ArtifactDB image (without tag) to use. |
| imagePullPolicy | string | `"IfNotPresent"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hostname | string | `nil` | Specify the hostname for ingress route rules. Working in combination with `prefix`, see below. |
| ingress.namespace_labels | object | `{"kubernetes.io/metadata.name":"ingress"}` | Matching labels to identify which namespace Traefik/NGINX is deployed this is used in a network policy to allow ingress between the ingress controller and this instance default is the k8s label containing namespace name metadata |
| ingress.prefix | string | `nil` | Specify the path prefix for ingress route rules. If `instance_version` is specified, it is appended to the path prefix.  The combination of the 3 parameters define the ingress rules. Example 1: api name as a subdomain - ingress.hostname: myapi.mycompany.com - instance_version: v3 - ingress.prefix: null => route: myapi.mycompany.com/v3 Example 2: api name as a path prefix - ingress.hostname: mycompany.com - instance_version: v7 - ingress.prefix: myapi => route: mycompany.com/myapi/v3 |
| mountLocalCode | bool | `false` | In a local development environment like k3d, ability to mount local source code directly into containers |
| mountLocalLib | bool | `false` | In a local development environment like k3d, ability to mount library code (artifactdb-{backend,identifiers,utils},...) into containers. Usefull to share the same libs accross different deployments. |
| nameOverride | string | `""` | Force chart name, otherwise generated by Helm |
| namespaceOverride | string | `nil` | Force namespace name, otherwise taken from Helm CLI |
| network_policy.enabled | bool | `true` | An |
| nodeSelector | object | `{}` |  |
| podAnnotations."reloader.stakater.com/auto" | string | `"true"` |  |
| postgresql.enabled | bool | `false` | Deploys a local PostgreSQL database. Mostly for dev purposes, production deployments should preferrably use an externally maintained instance (eg. AWS RDS), referenced in the instance's configuration file. |
| postgresql.existingSecret | string | `"pg-credentials"` |  |
| postgresql.fullnameOverride | string | `"postgresql"` |  |
| postgresql.usePasswordFile | bool | `true` |  |
| rabbitmq.auth.erlangCookie | string | `"RABBITMQ_ERLANG_COOKIE"` |  |
| rabbitmq.auth.password | string | `"abc123"` |  |
| rabbitmq.auth.username | string | `"user"` |  |
| rabbitmq.clustering.forceBoot | string | `"yes"` |  |
| rabbitmq.fullnameOverride | string | `"rabbitmq"` |  |
| rabbitmq.image.pullSecrets | list | `[]` | Optional docker registry secret to pull the rabbitmq image, in case of "anon pull limits reached" errors... |
| rabbitmq.nodeSelector | object | `{}` |  |
| rabbitmq.persistence.enabled | bool | `true` |  |
| rabbitmq.replicaCount | int | `2` | Number of masters (2 recommended for production) |
| redis.cluster.enabled | bool | `true` | Enable Redis cluster deployment (recommended for production). |
| redis.fullnameOverride | string | `"redis"` |  |
| redis.master.nodeSelector | object | `{}` |  |
| redis.slave.nodeSelector | object | `{}` |  |
| redis.usePassword | bool | `false` |  |
| resources | object | `{}` | Specifies pod resources. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tag | string | `"main-be0d4e0"` | ArtifactDB image tag to use. |
| unittest.autorun | bool | `false` | Automatically runs the test suite as a Kubernetes Job. If false, spin up a Pod that can be used interactively. |
| unittest.base_url | string | `nil` |  |
| unittest.enabled | bool | `false` | Deploy a `testsuite` pod used to run unit tests. |
| unittest.remove | bool | `true` | Remove test suite code, which can be destructive and be dangerous to keep in a non-dev environment. |
| unittest.verbose | bool | `false` | Enable verbose output from running test suite. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
