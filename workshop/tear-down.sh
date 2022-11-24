#!/bin/bash
oc delete -f rest-heroes.yaml
oc delete -f rest-villains.yaml
oc delete -f fights-kafka.yaml
oc delete -f rest-fights.yaml
oc delete -f event-statistics.yaml
oc delete -f ui-super-heroes.yaml
oc delete -f otel.yaml
