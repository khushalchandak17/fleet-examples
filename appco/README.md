# AppCo Example

This example will deploy the [Istio SUSE Application Collection](https://docs.apps.rancher.io/reference-guides/istio/). 
The app will be deployed into the `istio-system` namespace. Note that you must have create the `application-collection` secret into the `istio-system` namespace using the [AppCo Username](https://apps.rancher.io/settings/profile) as username and the [AppCo Access token](https://apps.rancher.io/settings/access-tokens) as password.

```yaml
kind: GitRepo
apiVersion: fleet.cattle.io/v1alpha1
metadata:
  name: appcotest
  namespace: fleet-local
spec:
  repo: https://github.com/rancher/fleet-examples
  branch: master
  paths:
  - appco
```