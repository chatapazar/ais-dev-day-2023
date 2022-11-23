#!/bin/bash

####################################################
# Functions
####################################################

provision_devspaces_project_in_advance() {
    oc login -u opentlc-mgr -p $ADMIN_PASSWORD --insecure-skip-tls-verify

    for ((i = 1; i <= $totalUsers; i++)); do
        project=user$i-devspaces
        oc label namespace $project app.kubernetes.io/part-of=che.eclipse.org
        oc label namespace $project app.kubernetes.io/component=workspaces-namespace
        oc annotate namespace $project che.eclipse.org/username=$user
    done
}

create_projects() {
    for ((i = 1; i <= $totalUsers; i++)); do
        oc login -u user$i -p $USER_PASSWORD --insecure-skip-tls-verify
        oc new-project user$i-devspaces
        oc new-project user$i-superheros
    done
}

####################################################
# Main (Entry point)
####################################################
totalUsers=$1

create_projects
provision_devspaces_project_in_advance
