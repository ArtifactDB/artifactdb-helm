# ArtifactDB Helm

Deploying an ArtifactDB backend running on Kubernetes, using Helm.

The Helm Chart available here allows to deploy an instance of ArtifactDB in a generic way:

- by directly using the chart and providing customization, such as the docker image, name, etc...
- as a subchart, while the instance itself contains specific deployment details, such as additional templates, files,
  etc...


## Dependencies

- [helm-docs](https://github.com/norwoodj/helm-docs)
- [pre-commit](https://pre-commit.com/#install)

The combination allows to automatically generate Helm docs. To set that up:

```
pre-commit install
pre-commit install-hooks
```

Pushing to Chart Museum requires the [cm-push](https://github.com/chartmuseum/helm-push):

```
helm plugin install https://github.com/chartmuseum/helm-push
```

The Makefile target `push-dev` and `push-prd` expects to push to a Helm repo named `adb-dev` and `adb-prd`. These
can be referenced using:

```
helm repo add adb-dev [URL]
helm repo add adb-prd [URL]
```

The command `make push env=[ENV]` can be used to point to another Helm repo named `adb-[ENV]`.
