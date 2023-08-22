#!/bin/bash

heroes_db_deployment_template() {
    echo $USER_NAMESPACE
    SERVICE_NAME=heroes-db
    DB_USERNAME=superman
    DB_PASSWORD=superman
    DB_NAME=heroes_database
    DB_HOST=$SERVICE_NAME.$USER_NAMESPACE.svc
    PGPASSWORD=$DB_PASSWORD

    oc new-app --template=postgresql-persistent \
        --param POSTGRESQL_USER=$DB_USERNAME \
        --param POSTGRESQL_PASSWORD=$DB_PASSWORD \
        --param POSTGRESQL_DATABASE=$DB_NAME \
        --param VOLUME_CAPACITY=1Gi \
        --param DATABASE_SERVICE_NAME=$SERVICE_NAME \
        --labels=app=$SERVICE_NAME,app.openshift.io/runtime=postgresql \
        --name=$SERVICE_NAME \
        --as-deployment-config=false \
        -n $USER_NAMESPACE

    sleep 5
    isReady=0

    while [[ $isReady -lt 1 ]]; do
        isReady=$(oc get dc $SERVICE_NAME -o yaml -n $USER_NAMESPACE | jq -e .status.readyReplicas)
        sleep 1
    done

    #Initial data
    curl https://raw.githubusercontent.com/rhthsa/ktcs-account-day-2023/main/manifest/super-heroes/heroes-db-init.sql -o heroes-db-init.sql
    psql -h $DB_HOST -U $DB_USERNAME -d $DB_NAME -f heroes-db-init.sql

    #Connect to DB
    #psql postgresql://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME
}

villains_db_deployment_template() {
    SERVICE_NAME=villains-db
    DB_USERNAME=superbad
    DB_PASSWORD=superbad
    DB_NAME=villains_database
    DB_HOST=$SERVICE_NAME.$USER_NAMESPACE.svc
    PGPASSWORD=$DB_PASSWORD

    oc new-app --template=postgresql-persistent \
        --param POSTGRESQL_USER=$DB_USERNAME \
        --param POSTGRESQL_PASSWORD=$DB_PASSWORD \
        --param POSTGRESQL_DATABASE=$DB_NAME \
        --param VOLUME_CAPACITY=1Gi \
        --param DATABASE_SERVICE_NAME=$SERVICE_NAME \
        --labels=app=$SERVICE_NAME,app.openshift.io/runtime=postgresql \
        --name=$SERVICE_NAME \
        --as-deployment-config=false \
        -n $USER_NAMESPACE

    sleep 5
    isReady=0

    while [[ $isReady -lt 1 ]]; do
        isReady=$(oc get dc $SERVICE_NAME -o yaml -n $USER_NAMESPACE | jq -e .status.readyReplicas)
        sleep 1
    done

    #Initial data
    curl https://raw.githubusercontent.com/rhthsa/ktcs-account-day-2023/main/manifest/super-heroes/villains-db-init.sql -o villains-db-init.sql
    psql -h $DB_HOST -U $DB_USERNAME -d $DB_NAME -f villains-db-init.sql
}

db_deployment_template() {
    heroes_db_deployment_template
    villains_db_deployment_template
}

db_deployment_yaml() {
    if [[ $1 = "all" ]]; then
        oc apply -f ../manifest/super-heroes/heroes-db.yml
    fi
    oc apply -f ../manifest/super-heroes/fights-db.yml
    oc apply -f ../manifest/super-heroes/villains-db.yml
}

app_deployment_yaml() {
    if [[ $1 = "all" ]]; then
        oc apply -f ../manifest/super-heroes/heroes-app.yml
    fi
    oc apply -f ../manifest/super-heroes/fights-app.yml
    oc apply -f ../manifest/super-heroes/villains-app.yml
    oc apply -f ../manifest/super-heroes/statistics-app.yml
    oc apply -f ../manifest/super-heroes/ui-super-heroes-app.yml
}

kafka_deployment_yaml() {
    oc apply -f ../manifest/super-heroes/kafka.yml

}

service_registry_deployment_yaml() {
    oc apply -f ../manifest/super-heroes/apicurio-registry.yml
}


####################################################
# Main (Entry point)
####################################################

option=$1
export USER_NAMESPACE=$2

if [[ $option = "all" ]]; then
    db_deployment_yaml all
    app_deployment_yaml all
    kafka_deployment_yaml
    service_registry_deployment_yaml

elif [[ $option = "db" ]]; then
    db_deployment_yaml few

elif [[ $option = "app" ]]; then
    app_deployment_yaml few

elif [[ $option = "kafka" ]]; then
    kafka_deployment_yaml

elif [[ $option = "registry" ]]; then
    service_registry_deployment_yaml
else
    echo "invalid argument!"
fi

exit 0