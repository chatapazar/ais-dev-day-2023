#!/bin/bash
CONTROL_PLANE=project2-istio-system
DEFAULT_CERT=$(oc get secret -n openshift-ingress --no-headers -o custom-columns='Name:.metadata.name'|grep ingress-certs)
oc get secret $DEFAULT_CERT -n openshift-ingress  -o yaml \
| sed 's/namespace: .*/namespace: '$CONTROL_PLANE'/'   \
| sed  's/name: '$DEFAULT_CERT'/name: ingress-certs/' \
| oc apply -n $CONTROL_PLANE -f -