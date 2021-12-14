#!/usr/bin/env bash
mpdev verify --deployer=gcr.io/gke-istio-test-psb/tsb-operator/deployer:1.4 | tee verify.log
