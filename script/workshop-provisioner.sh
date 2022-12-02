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

enable_user_workload_monitoring()
{
    echo
    echo "Enabling monitoring for user-defined projects..."
    echo

    oc apply -f ../manifest/cluster-monitoring-config.yml -n openshift-monitoring
}

install_operator() {
    operatorNameParam=$1
    operatorDescParam=$2
    ymlFilePathParam=$3
    project=$4

    echo
    echo "Installing $operatorDescParam to $project project..."
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

setup_gitea() {
    echo "Installing CatalogSource for Gitea Operator..."
    echo

    oc apply -f https://raw.githubusercontent.com/redhat-gpte-devopsautomation/gitea-operator/master/catalog_source.yaml

    operatorName=gitea-operator
    operatorDesc="Gitea Operator"
    ymlFilePath=../manifest/gitea-subscription.yml
    project=openshift-operators

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project

    project=gitea

    echo
    echo "Creating $project project..."
    echo

    oc new-project $project

    echo
    echo "Setting up Getea instance and import repository..."
    echo

    oc apply -f ../manifest/gitea.yml -n $project

    echo
    echo "Waiting for Gitea instance to be available..."
    echo

    available="false"

    while [[ $available != "true" ]]; do
        sleep 5
        available=$(oc get giteas.gpte.opentlc.com git -o jsonpath='{.status.userSetupComplete}' -n $project)
    done

    echo "Gitea instance is now available!"
    echo
}

setup_dev_spaces() {
    project=openshift-operators
    operatorName=devspaces
    operatorDesc="Red Hat OpenShift Dev Spaces"
    ymlFilePath=../manifest/devspaces-subscription.yml

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project

    project=redhat-openshift-devspaces

    echo
    echo "Creating $project project..."
    echo

    oc new-project $project

    echo
    echo "Setting up Red Hat OpenShift Dev Spaces instance..."
    echo

    oc apply -f ../manifest/devspaces.yml -n $project

    echo
    echo "Waiting for Red Hat OpenShift Dev Spaces instance to be available..."
    echo

    available="false"

    while [[ $available != "Active" ]]; do
        sleep 5
        available=$(oc get checlusters.org.eclipse.che devspaces -o jsonpath='{.status.chePhase}' -n $project)
    done

    echo "Red Hat OpenShift Dev Spaces instance is now available!"
    echo
}

install_dev_workspaces() {
    project=openshift-operators
    operatorName=devworkspace-operator
    operatorDesc="Dev Workspace Operator"
    ymlFilePath=../manifest/devworkspace-subscription.yml

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

install_amq_streams() {
    operatorName=amq-streams
    operatorDesc="Red Hat Integration - AMQ Streams"
    ymlFilePath=../manifest/amq-stream-subscription.yml
    project=openshift-operators

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

install_git_ops() {
    operatorName=openshift-gitops-operator
    operatorDesc="Red Hat OpenShift GitOps"
    ymlFilePath=../manifest/gitops-subscription.yml
    project=openshift-operators

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

install_distributed_tracing_platform() {
    # project=openshift-distributed-tracing
    project=openshift-operators
    # echo
    # echo "Creating $project project..."
    # echo

    # oc new-project $project

    operatorName=jaeger-product
    operatorDesc="Red Hat OpenShift distributed tracing platform"
    ymlFilePath=../manifest/distributed-tracing-platform-subscription.yml

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

install_distributed_tracing_data_collection() {
    operatorName=opentelemetry-product
    operatorDesc="Red Hat OpenShift distributed tracing data collection"
    ymlFilePath=../manifest/distributed-tracing-data-collection-subscription.yml
    project=openshift-operators

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

install_service_mesh() {
    operatorName=servicemeshoperator
    operatorDesc="Red Hat OpenShift Service Mesh"
    ymlFilePath=../manifest/service-mesh-subscription.yml
    project=openshift-operators

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

install_kiali() {
    operatorName=kiali-ossm
    operatorDesc="Kiali Operator"
    ymlFilePath=../manifest/kiali-subscription.yml
    project=openshift-operators

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

install_service_registry() {
    operatorName=service-registry-operator
    operatorDesc="Red Hat Integration - Service Registry Operator"
    ymlFilePath=../manifest/service-registry-subscription.yml
    project=openshift-operators

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

setup_web_terminal() {
    operatorName=web-terminal
    operatorDesc="Web Terminal"
    ymlFilePath=../manifest/web-terminal-subscription.yml
    project=openshift-operators

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project

    # Customize Web Terminal template see: https://github.com/redhat-developer/web-terminal-operator/
    oc annotate devworkspacetemplates.workspace.devfile.io web-terminal-tooling 'web-terminal.redhat.com/unmanaged-state=false' -n $project
    oc patch devworkspacetemplates.workspace.devfile.io web-terminal-tooling --type=merge --patch-file=../manifest/web-terminal-tooling.json -n $project

    oc delete subscription web-terminal-operator -n $project
    sleep 5

    install_operator $operatorName "$operatorDesc" $ymlFilePath $project
}

setup_nexus() {
    project=nexus

    echo
    echo "Creating $project project..."
    echo

    oc new-project $project

    echo "Importing Sonatype Nexus Repository Manager 3 OSS template..."
    echo

    oc create -f https://raw.githubusercontent.com/audomsak/openshift-sonatype-nexus/master/nexus3-persistent-template-secure.yaml -n $project

    echo
    echo "Setting up Sonatype Nexus Repository Manager instance..."
    echo

    oc new-app nexus3-persistent

    echo
    echo "Waiting for Sonatype Nexus Repository Manager instance to be available..."
    echo

    available="false"

    while [[ $available != "true" ]]; do
        sleep 5
        available=$(oc get pods -l deploymentconfig='nexus' -o jsonpath='{.items[*].status.containerStatuses[0].ready}' -n $project)
    done

    echo "Sonatype Nexus Repository Manager instance is now available!"
    echo
}

preload_nexus_artefacts() {
    echo
    echo "Building a project for workshop to preload all required Maven artefacts to Nexus Repository..."
    echo

    project=default

    # Build a project to preload required artefacts into Nexus so next build will be fast! i.e. when running workshop
    oc run -n $project maven-build --image=quay.io/asuksunt/web-terminal-tooling:1.0 \
        --restart=OnFailure \
        --command -- sh -c 'git clone http://git.gitea.svc.cluster.local:3000/lab-user/quarkus-super-heroes.git; cd quarkus-super-heroes; mvn compile -s maven-setting.xml'
}

####################################################
# Main (Entry point)
####################################################
echo
echo "Super Heroes on OpenShift Workshop Provisioner"
repeat '-'

enable_user_workload_monitoring
repeat '-'

setup_gitea
repeat '-'

install_dev_workspaces
repeat '-'

setup_dev_spaces
repeat '-'

install_amq_streams
repeat '-'

install_git_ops
repeat '-'

install_distributed_tracing_platform
repeat '-'

install_distributed_tracing_data_collection
repeat '-'

install_service_mesh
repeat '-'

install_kiali
repeat '-'

install_service_registry
repeat '-'

 setup_web_terminal
 repeat '-'

setup_nexus
repeat '-'

preload_nexus_artefacts
repeat '-'

oc project default

echo "Done!!!"
