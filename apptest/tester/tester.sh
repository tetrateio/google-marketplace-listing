#!/bin/bash
#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eo pipefail

until [[kubectl get controlplane -n istiosystem && kubectl get managementplane  -n tsb]];
    do echo "Waiting for ControlPlane to be available"; sleep 5;
done

kubectl delete ingressgateways.install.tetrate.io --all --all-namespaces

kubectl -n istio-gateway scale deployment tsb-operator-data-plane --replicas=0

kubectl -n istio-gateway delete istiooperators.install.istio.io --all

kubectl -n istio-gateway delete deployment --all 

kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io tsb-operator-data-plane-egress tsb-operator-data-plane-ingress tsb-operator-data-plane-tier1 --ignore-not-found 

kubectl delete mutatingwebhookconfigurations.admissionregistration.k8s.io tsb-operator-data-plane-egress tsb-operator-data-plane-ingress tsb-operator-data-plane-tier1 --ignore-not-found

kubectl delete controlplanes.install.tetrate.io --all --all-namespaces --ignore-not-found

kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io tsb-operator-control-plane --ignore-not-found

kubectl delete  mutatingwebhookconfigurations.admissionregistration.k8s.io tsb-operator-control-plane --ignore-not-found

kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io xcp-edge-istio-system --ignore-not-found

kubectl delete namespace tsb-system xcp-multicluster 

tctl install manifest cluster-operators --registry=$REPO | kubectl delete -f - --ignore-not-found

kubectl delete clusterrole xcp-operator-edge

kubectl delete clusterrolebinding xcp-operator-edge

kubectl delete crd clusters.xcp.tetrate.io controlplanes.install.tetrate.io edgexcps.install.xcp.tetrate.io egressgateways.gateway.xcp.tetrate.io egressgateways.install.tetrate.io gatewaygroups.gateway.xcp.tetrate.io globalsettings.xcp.tetrate.io ingressgateways.gateway.xcp.tetrate.io ingressgateways.install.tetrate.io securitygroups.security.xcp.tetrate.io  securitysettings.security.xcp.tetrate.io servicedefinitions.registry.tetrate.io  serviceroutes.traffic.xcp.tetrate.io  tier1gateways.gateway.xcp.tetrate.io tier1gateways.install.tetrate.io trafficgroups.traffic.xcp.tetrate.io trafficsettings.traffic.xcp.tetrate.io workspaces.xcp.tetrate.io workspacesettings.xcp.tetrate.io --ignore-not-found

tctl delete cluster <clustername>

kubectl -n tsb delete managementplanes.install.tetrate.io --all

kubectl -n tsb delete deployment tsb-operator-management-plane

kubectl delete \
    validatingwebhookconfigurations.admissionregistration.k8s.io \
    tsb-operator-management-plane
kubectl delete \
    mutatingwebhookconfigurations.admissionregistration.k8s.io \
    tsb-operator-management-plane
kubectl delete \
    validatingwebhookconfigurations.admissionregistration.k8s.io \
    xcp-central-tsb
kubectl delete \
    mutatingwebhookconfigurations.admissionregistration.k8s.io \
    xcp-central-tsb

tctl install manifest management-plane-operator \
    --registry=$REPO | \
    kubectl delete -f - --ignore-not-found
kubectl delete clusterrole xcp-operator-central
kubectl delete clusterrolebinding xcp-operator-central

kubectl delete crd \
    centralxcps.install.xcp.tetrate.io \
    clusters.xcp.tetrate.io \
    egressgateways.gateway.xcp.tetrate.io \
    egressgateways.install.tetrate.io \
    gatewaygroups.gateway.xcp.tetrate.io \
    globalsettings.xcp.tetrate.io \
    ingressgateways.gateway.xcp.tetrate.io \
    ingressgateways.install.tetrate.io \
    managementplanes.install.tetrate.io \
    securitygroups.security.xcp.tetrate.io \
    securitysettings.security.xcp.tetrate.io \
    servicedefinitions.registry.tetrate.io \
    serviceroutes.traffic.xcp.tetrate.io \
    tier1gateways.gateway.xcp.tetrate.io \
    tier1gateways.install.tetrate.io \
    trafficgroups.traffic.xcp.tetrate.io \
    trafficsettings.traffic.xcp.tetrate.io \
    workspaces.xcp.tetrate.io \
    workspacesettings.xcp.tetrate.io
    
