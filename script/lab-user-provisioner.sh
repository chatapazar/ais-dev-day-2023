#!/bin/bash

####################################################
# Functions
####################################################
repeat() {
    echo
    for i in {1..120}; do
        echo -n "$1"
    done
    echo
}

provision_devspaces_project_in_advance() {
    oc login -u opentlc-mgr -p $ADMIN_PASSWORD --insecure-skip-tls-verify

    for ((i = 1; i <= $totalUsers; i++)); do
        project=user$i-devspaces
        oc label namespace $project app.kubernetes.io/part-of=che.eclipse.org
        oc label namespace $project app.kubernetes.io/component=workspaces-namespace
        oc annotate namespace $project che.eclipse.org/username=$user
        repeat '-'
    done
}

create_projects() {
    for ((i = 1; i <= $totalUsers; i++)); do
        oc login -u user$i -p $USER_PASSWORD --insecure-skip-tls-verify
        oc new-project user$i-devspaces
        oc new-project user$i-superheros
        oc new-project user$i-istio-system
        repeat '-'
    done
}

install_operator() {
    operatorNameParam=$1
    operatorDescParam=$2
    ymlFilePathParam=$3
    project=$4

    echo
    echo "Installing $operatorDescParam..."
    echo

    oc apply -f $ymlFilePathParam -n $project

    echo
    echo "Waiting for $operatorDescParam to be available..."
    echo

    available="False"

    while [[ $available != "True" ]]; do
        sleep 5
        available=$(oc get -n $project operators.operators.coreos.com \
            $operatorNameParam.$project \
            -o jsonpath='{.status.components.refs[?(@.apiVersion=="apps/v1")].conditions[?(@.type=="Available")].status}')
    done

    echo "$operatorDescParam is now available!"
}

install_grafana() {
    oc login -u opentlc-mgr -p $ADMIN_PASSWORD --insecure-skip-tls-verify

    for ((i = 1; i <= $totalUsers; i++)); do
        project=user$i-superheros
        sed "s/NAMESPACE/${project}/g" ../manifest/operator-group.yml | oc apply -f- -n $project

        operatorName=grafana-operator
        operatorDesc="Grafana Operator"
        ymlFilePath=../manifest/grafana-subscription.yml

        install_operator $operatorName "$operatorDesc" $ymlFilePath $project
        repeat '-'
    done
}

####################################################
# Main (Entry point)
####################################################
totalUsers=$1

create_projects
install_grafana
#provision_devspaces_project_in_advance
