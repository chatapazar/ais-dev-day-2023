#!/bin/bash
CONFIGMAP=example
PROJECT=project2
DATA=$(oc get cm $CONFIGMAP -n $PROJECT -o jsonpath='{.data}')
NUM=21
MAX=31
while [ $NUM -lt $MAX ];
do
 TEMP=$(echo $DATA|jq '. += { "account.user'${NUM}'":"apiKey, login" }')
 NUM=$(expr $NUM + 1)
 DATA=$TEMP
done
ONELINE=$(printf "%s" $DATA)
oc patch cm $CONFIGMAP -n $PROJECT  \
 -p '{"data":'$ONELINE'}'
