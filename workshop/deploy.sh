#!/bin/bash
oc apply -f rest-heroes.yaml
oc apply -f rest-villains.yaml
oc apply -f fights-kafka.yaml
# KAFKA_READY=False
# printf "Wait for Kafka\n"
# while [ $KAFKA_READY != "True" ];
# do
#   KAFKA_READY=$(oc get kafka/fights -o jsonpath='{.status.conditions[*].status}')
#   printf "."
# done
# printf "\n"
oc apply -f rest-fights.yaml
oc apply -f event-statistics.yaml
oc apply -f ui-super-heroes.yaml
oc apply -f otel.yaml
