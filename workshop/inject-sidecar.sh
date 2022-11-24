#!/bin/bash
deployments=( "rest-heroes" "rest-villains" "rest-fights" "ui-super-heroes" "event-statistics" "apicurio")
for deployment in "${deployments[@]}"; do
printf "Inject sidecar for $deployment\n"
oc patch deployment/$deployment \
-p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"true"}}}}}'
done
