# Phase 3: Integrating Helm for Deployment

**Assigned to**: Marc Badilla

## Deliverables

- [x] 1. Screenshots of the Helm repository being added and updated.
- [x] 2. Screenshots of the application deployed successfully using Helm.
- [x] 3. Screenshots or logs of the upgrade process showing changes being applied.
- [x] 4. Screenshots or logs demonstrating a successful rollback to a previous version.

## Proof

Helm is a package manager for Kubernetes. Application developers may use charts to define the Kubernetes resources needed for their applications. The intent is to allow anyone without extensive knowledge of the requisite Kubernetes resources to run the application.

### 1. Adding and Updating the Helm Repository

![Using the Helm command line tool to add and update the OpenTelemetry repository.](./0-add-and-update-repository.png)

This is the first step in successfully deploying the OpenTelemetry demo via Helm. To confirm that the Helm repository was updated, I double-checked the version numbers against the `opentelemetry-demo` Helm chart's [Artifact Hub page](https://artifacthub.io/packages/helm/opentelemetry-helm/opentelemetry-demo). At the time of writing this, the Helm chart's version was at `0.33.7` and its application version was at `1.12.0`. All of this matches the screenshot.

### 2. Successful Helm Deployment

![Using the Helm command line tool to install the OpenTelemetry demo into EKS.](./1-opentelemetry-demo-deployment.png)

In order to create a new namespace for the Helm deployment, I specified the `--create-namespace` and `--namespace` options. The former indicates that the namespace needs to be created while the latter specifies the name of the new namespace. All future commands targeting `my-otel-demo` will also need to specify the namespace.

### 3. Upgrade Process

![Using the Helm command line tool to make changes to the OpenTelemetry demo deployment.](./2-upgrade.png)

In order to demonstrate the upgrade process, I decided to change the `default.replicas` configuration from `1` to `3`. Prior to taking the screenshots, I have been playing around with the `helm upgrade` command; the screenshot as a result shows that this is the 6th revision.

![Confirming the upgrade process by checking the ReplicaSet resources.](./3-upgrade-confirm.png)

To perform a sanity check, I used `kubectl` to fetch a list of all ReplicaSet resources. As expected, replicas have been updated from `1` to `3`. (Note that not all ReplicaSet resources have been updated. The OpenTelemetry Artifact Hub page mentions that the setting I changed only affects "demo components").

### 4. Rollback Demonstration

![Using the Helm command line tool to rollback the OpenTelemetry demo deployment to the first revision.](./4-rollback.png)

In order to demonstrate the rollback process, I decided to rollback all the way back to the 1st revision (technically, the rollback still counts as a revision, making this the 7th revision). The expected behavior is that the `default.replicas` configuration will revert from `3` to `1`.

![Confirming the rollback process by checking the ReplicaSet resources.](./5-rollback-confirm.png)

To perform a sanity check, I used `kubectl` to fetch a list of all ReplicaSet resources. As expected, replicas have been reverted back to the default of `1`.
