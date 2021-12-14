#!/bin/bash

set -e

source ./var.sh

gcloud container clusters get-credentials $cluster_name --zone $zone --project $project

KUBE_CONTEXT="gke_${project}_${zone}_${cluster_name}"

kubectl config use-context ${KUBE_CONTEXT}

MP_ADDRESS=$(kubectl get svc -n tsb envoy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export ELASTIC_PASS=$(kubectl get secret -n elastic tsb-es-elastic-user -o go-template='{{ .data.elastic | base64decode }}')
tctl config clusters set $mp_cluster --bridge-address ${MP_ADDRESS}:8443 --tls-insecure

tctl config profiles set $mp_cluster --cluster $mp_cluster

tctl config profiles  set-current $mp_cluster

TCTL_LOGIN_ORG=tetrate TCTL_LOGIN_TENANT=tetrate TCTL_LOGIN_USERNAME=admin TCTL_LOGIN_PASSWORD=${tsb_password} tctl login

sed "s%#CP_CLUSTER#%${cluster_name}%g" artifacts/cp-cluster.yaml.tpl > artifacts/cp-cluster.yaml

tctl apply -f artifacts/cp-cluster.yaml

tctl install manifest cluster-operators --registry $HUB | kubectl apply -f -


tctl install manifest control-plane-secrets  --allow-defaults  --elastic-password $ELASTIC_PASS --elastic-username elastic  --elastic-ca-certificate "$(cat artifacts/es-ca-cert.pem)" --cluster $cluster_name --xcp-certs "$(tctl install cluster-certs --cluster $cluster_name)" | kubectl apply -f -

if kubectl create secret generic cacerts -n istio-system --from-file artifacts/ca-cert.pem --from-file artifacts/ca-key.pem --from-file artifacts/root-cert.pem --from-file artifacts/cert-chain.pem;then
  echo "cacerts  installed"
  fi


sed "s%#HUB#%${HUB}%g;s%#MP_HOST#%${MP_ADDRESS}%g;s%#CP_CLUSTER#%${cluster_name}%g" artifacts/cp.yaml.tpl > artifacts/cp.yaml
sleep 40
kubectl apply -f artifacts/cp.yaml







