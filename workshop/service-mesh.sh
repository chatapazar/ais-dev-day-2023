#!/bin/bash
CONTROL_PLANE=project2-istio-system
APP_NAMESPACE=project2
oc create -f workshop/smcp.yaml -n $CONTROL_PLANE
cat workshop/smmr.yaml | \
sed 's/NAMESPACE/'$APP_NAMESPACE'/' | \
oc oc create -n $CONTROL_PLANE -f -