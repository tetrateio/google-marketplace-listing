apiVersion: install.tetrate.io/v1alpha1
kind: ControlPlane
metadata:
  name: controlplane
  namespace: istio-system
spec:
  hub: #HUB#
  telemetryStore:
    elastic:
      host: tsb-es-http.elastic.svc
      port: 9200
      version: 7
      selfSigned: true
  managementPlane:
    host: #MP_HOST#
    port: 8443
    clusterName: #CP_CLUSTER#
  meshExpansion: {}
