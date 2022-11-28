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
    echo ""
    echo "Logging in as cluster administrator to pre-provisioning devspeces for users..."
    echo

    oc login -u opentlc-mgr -p $ADMIN_PASSWORD --insecure-skip-tls-verify
    repeat '-'

    for i in $( seq 1 $totalUsers )
    do
        project=user$i-devspaces
        oc label namespace $project app.kubernetes.io/part-of=che.eclipse.org
        oc label namespace $project app.kubernetes.io/component=workspaces-namespace
        oc annotate namespace $project che.eclipse.org/username=$user
    done
    repeat '-'
}

create_projects() {
    echo

    for i in $( seq 1 $totalUsers )
    do
        echo ""
        echo "Logging in as user$i user to create projects..."
        echo

        oc login -u user$i -p $USER_PASSWORD --insecure-skip-tls-verify
        oc new-project user$i-devspaces
        #oc delete project user$i-superheroes
        oc new-project user$i-super-heroes
        oc new-project user$i-istio-system
        oc new-project user$i-monitoring
    done
    repeat '-'
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

install_grafana() {
    echo ""
    echo "Logging in as cluster administrator to install operator..."
    echo

    oc login -u opentlc-mgr -p $ADMIN_PASSWORD --insecure-skip-tls-verify
    repeat '-'

    for i in $( seq 1 $totalUsers )
    do
        project=user$i-monitoring
        sed "s/NAMESPACE/${project}/g" ../manifest/operator-group.yml | oc apply -f- -n $project

        operatorName=grafana-operator
        operatorDesc="Grafana Operator"
        ymlFilePath=../manifest/grafana-subscription.yml

        install_operator $operatorName "$operatorDesc" $ymlFilePath $project
        repeat '-'
    done
}

set_default_role_argocd(){
    oc login -u opentlc-mgr -p $ADMIN_PASSWORD --insecure-skip-tls-verify
    oc patch cm/argocd-rbac-cm -p '{"data":{"policy.default": "role:admin" }}' -n openshift-gitops
}


create_argocd_user() {
    ##manual add argocd-cm.yml to argocd-cm
    ##data:
    ##  admin.enabled: 'true'
    ##  accounts.user1: apiKey, login
    ##  accounts.user2: apiKey, login
    NUM=1
    MAX=$totalUsers
    DATA=$(oc get cm argocd-cm -n openshift-gitops -o jsonpath='{.data}')
    NUM=1
    MAX=5
    while [ $NUM -lt $MAX ];
    do
        TEMP=$(echo $DATA|jq '. += { "account.user'${NUM}'":"apiKey, login" }')
        TEMP=$(echo $DATA|jq '. += { "account.user1":"apiKey, login" }')
        cat $DATA | jq '. +={"a":"b"}'
        NUM=$(expr $NUM + 1)
        DATA=$TEMP
    done
    echo $DATA
    oc patch cm example -n project2  --type json --patch '[{ "op": "replace", "path": "/data", "value": '$DATA'}]'

    oc get cm argocd-cm -n openshift-gitops -o yaml > ../manifest/argocd-cm.yml
    for i in $( seq 1 $totalUsers )
    do
        username=user$i
        echo "  accounts.$username: apiKey, login" >> ../manifest/argocd-cm.yml
    done
    oc apply -f ../manifest/argocd-cm.yml
}

update_argocd_password(){
    oc adm policy add-cluster-role-to-user cluster-admin -z openshift-gitops-argocd-application-controller -n openshift-gitops
    ARGOCD=$(oc get route/openshift-gitops-server -n openshift-gitops -o jsonpath='{.spec.host}')
    echo https://$ARGOCD
    PASSWORD=$(oc extract secret/openshift-gitops-cluster -n openshift-gitops --to=-) 2>/dev/null
    echo $PASSWORD
    argocd login $ARGOCD  --insecure --username admin --password $PASSWORD
    for i in $( seq 1 $totalUsers )
    do
        username=user$i
        argocd account update-password --account $username --new-password openshift --current-password $PASSWORD
    done
}

add_monitor_edit_role_to_user()
{
    echo ""
    echo "Logging in as cluster administrator to add monitor edit role to users..."
    echo

    oc login -u opentlc-mgr -p $ADMIN_PASSWORD --insecure-skip-tls-verify
    repeat '-'

    for i in $( seq 1 $totalUsers )
    do
        oc adm policy add-role-to-user monitoring-edit user$i -n user$i-super-heroes
    done
}

####################################################
# Main (Entry point)
####################################################
totalUsers=$1

#create_projects
#install_grafana
#add_monitor_edit_role_to_user
#create_argocd_user
#set_default_role_argocd
update_argocd_password
#provision_devspaces_project_in_advance
