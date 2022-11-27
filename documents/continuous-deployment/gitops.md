# Understanding GitOps

![GitOps](image/gitops.png)

## What is GitOps?

GitOps uses Git repositories as a single source of truth to deliver infrastructure as code. Submitted code checks the CI process, while the CD process checks and applies requirements for things like security, infrastructure as code, or any other boundaries set for the application framework. All changes to code are tracked, making updates easy while also providing version control should a rollback be needed.

GitOps delivers:

* A standard workflow for application development
* Increased security for setting application requirements upfront
* Improved reliability with visibility and version control through Git
* Consistency across any cluster, any cloud, and any on-premise environment
Many other tools can be used together to build a GitOps framework. For example, git repositories, Kubernetes, continuous integration/continuous delivery (CI/CD) tools, and configuration management tools.

## About GitOps

GitOps is a declarative way to implement continuous deployment for cloud native applications. You can use GitOps to create repeatable processes for managing OpenShift Container Platform clusters and applications across multi-cluster Kubernetes environments. GitOps handles and automates complex deployments at a fast pace, saving time during deployment and release cycles.

The GitOps workflow pushes an application through development, testing, staging, and production. GitOps either deploys a new application or updates an existing one, so you only need to update the repository; GitOps automates everything else.

GitOps is a set of practices that use Git pull requests to manage infrastructure and application configurations. In GitOps, the Git repository is the only source of truth for system and application configuration. This Git repository contains a declarative description of the infrastructure you need in your specified environment and contains an automated process to make your environment match the described state. Also, it contains the entire state of the system so that the trail of changes to the system state are visible and auditable. By using GitOps, you resolve the issues of infrastructure and application configuration sprawl.

![GitOps in a nutshell](image/gitops-in-a-nutshell.png)

GitOps defines infrastructure and application definitions as code. Then, it uses this code to manage multiple workspaces and clusters to simplify the creation of infrastructure and application configurations. By following the principles of the code, you can store the configuration of clusters and applications in Git repositories, and then follow the Git workflow to apply these repositories to your chosen clusters. You can apply the core principles of developing and maintaining software in a Git repository to the creation and management of your cluster and application configuration files.

## About Red Hat OpenShift GitOps

Red Hat OpenShift GitOps ensures consistency in applications when you deploy them to different clusters in different environments, such as: development, staging, and production. Red Hat OpenShift GitOps organizes the deployment process around the configuration repositories and makes them the central element. It always has at least two repositories:

1. Application repository with the source code

2. Environment configuration repository that defines the desired state of the application

These repositories contain a declarative description of the infrastructure you need in your specified environment. They also contain an automated process to make your environment match the described state.

![GitOps wtih ArgoCD](image/argocd.png)

Red Hat OpenShift GitOps uses Argo CD to maintain cluster resources. Argo CD is an open-source declarative tool for the continuous integration and continuous deployment (CI/CD) of applications. Red Hat OpenShift GitOps implements Argo CD as a controller so that it continuously monitors application definitions and configurations defined in a Git repository. Then, Argo CD compares the specified state of these configurations with their live state on the cluster.

![ArgoCD Push and Pull model](image/argocd-push-pull-model.png)

Argo CD reports any configurations that deviate from their specified state. These reports allow administrators to automatically or manually resync configurations to the defined state. Therefore, Argo CD enables you to deliver global custom resources, like the resources that are used to configure OpenShift Container Platform clusters.

![OpenShift Pipelines & GitOps](image/ocp-pipeline-and-gitops.webp)

## Review Current Topology
* Prerequisite
  * Complete previous workshop, Make sure you have deployed the following components:
    - fight-kafka
    - fight microservice
    - heroes microservice
    - villians microservice
    - super heroes ui
  * Check Current Topology of your userX-superheroes like this (in userX-superheroes)
    ![](image/cd-1.png)

## Review Deployment Configuration in Git Repository & Kustomized Configuration Management
* Start with [Kustomized](https://kustomize.io)
  ![](image/kustomize-1.png)
  Kustomize provides a solution for customizing Kubernetes resource   configuration free from templates and DSLs.

  Kustomize lets you customize raw, template-free YAML files for multiple purposes, leaving the original YAML untouched and usable as is.

  Kustomize targets kubernetes; it understands and can patch kubernetes style API objects. It’s like make, in that what it does is declared in a file, and it’s like sed, in that it emits edited text.

  With kustomize, your team can ingest any base file updates for your underlying components while keeping use-case specific customization overrides intact. Another benefit of utilizing patch overlays is that they add dimensionality to your configuration settings, which can be isolated for troubleshooting misconfigurations or layered to create a framework of most-broad to most-specific configuration specifications.

  To recap, Kustomize relies on the following system of configuration management layering to achieve reusability:

  - Base Layer - Specifies the most common resources
  - Patch Layers - Specifies use case specific resources
  
    ![](image/kustomize-2.png)
    

* Review Kustomize Resource in Git Repository
  - For this workshop, we will deploy event-statistics application for consume data (fight information) from AMQ Streams by Red Hat OpenShift GitOps
    ![](image/cd-0.png)
  - check you cluster name from your current openshift workshop console
    - such as your current workshop console URL is 'https://console-openshift-console.apps.cluster-4qhvp.4qhvp.sandbox689.opentlc.com'. 
    - your CLUSTER_NAME is 'cluster-4qhvp.4qhvp.sandbox689.opentlc.com'
  - open browser to https://git-gitea.apps.CLUSTER_NAME/lab-admin/developer-advocacy-2022
    ![](image/cd-2.png)
  - go to manifest/apps-kustomize
    ![](image/cd-3.png)
  - go to base folder
    ![](image/cd-4.png)
    - review following file:
      - kustomization.yml
      - rolebinding.yml
      - configmap.yml
      - secret.yml
      - event-statistics.yml
      - event-statistics-service.yml
      - route.yml
  - go to overlays/dev folder
    ![](image/cd-5.png)
    - review following file:
      - kustomization.yml
      - event-statistics.yml
    - content of event-statistics.yml in overlays/dev/kustomization.yml
      ![](image/cd-6.png)
  - compare content of event-statistics.yml between base folder and overlays/dev folder (about resource request and limit)
    - resource request & limit in base/event-statistics.yml
      ```yaml
                resources:
            limits:
              memory: 256Mi
            requests:
              memory: 128Mi
      ```
    - resource request & limit in overlays/dev/event-statistics.yml
      ```yaml
                resources:
            limits:
              memory: 512Mi
            requests:
              memory: 256Mi
      ``` 
  - summary kustomize structure of this workshop
    ```bash
    manifest/apps-kustomize
    ├── base
    │   ├── configmap.yml
    │   ├── event-statistics-service.yml
    │   ├── event-statistics.yml
    │   ├── kustomization.yml
    │   ├── rolebinding.yml
    │   ├── route.yml
    │   └── secret.yml
    └── overlays
        └── dev
            ├── event-statistics.yml
            └── kustomization.yml
    ```

## Create Applicaiton in OpenShift GitOps
* Login to OpenShift GitOps (ArgoCD)
  - open your developer console, go to your project 'userX-superheroes' (replace X with your username)
  - Go to top right of developer console, Navigate to the table menu (It's to the left of the plus sign menu.) --> OpenShift GitOps --> Cluster Argo CD.
    ![](image/cd-8.png)
  - For the first time to open Argo CD Console. Your Browser will warining about connection(is not private) Because we used self sign certification. Please accecpt this risk and proceed to Argo CD Cosole
    ![](image/cd-7.png)
    ![](image/cd-9.png)
  - use local user for login, type your username and password (same with your openshift login, such as user5/openshift), click 'SIGN IN'
    ![](image/cd-10.png)
  - Review Argo CD Console
    ![](image/cd-11.png)
* Create Application
  - Click 'NEW APP' icon from left top of console to Create Application
  ![](image/cd-12.png)
  - in create application panel, config following information:
    ![](image/cd-13.png)
    In General part
    - Application Name: userX-event-statistics 
      - change X to your username such as user5-event-statistics
    - Project: default
    - SYNC POLICY: Manual
    - leave default for sync option
  - in Source part
    ![](image/cd-14.png)
    - set Repository URL: https://git-gitea.apps.CLUSTER_NAME/lab-admin/developer-advocacy-2022
      - Change CLUSTER_NAME to your current workshop cluster
      - such as your current workshop console URL is 'https://console-openshift-console.apps.cluster-4qhvp.4qhvp.sandbox689.opentlc.com'. 
      - your CLUSTER_NAME is 'cluster-4qhvp.4qhvp.sandbox689.opentlc.com' 
    - Revision: HEAD
    - Path: manifest/apps-kustomize/overlays/dev
  - in Destination part
    ![](image/cd-15.png)
    - Cluster URL: https://kubernetes.default.svc
    - Namespace: userX-superheroes
      - change X to your username such as user5-superheroes
  - Leave default in last part (Source Type/Kustomize)
    ![](image/cd-16.png)
  - Click Create and wait untill your application show in console
  - if you don't found your application (because this workshop, we share argo cd to all user). you can filter with your namespaces such as 'userX-superheroes' 
    ![](image/cd-17.png)
  - see status of your application set to 'OutOfSync'

* Sync (Deploy) Application
  - Next Step, We will start sync (deploy) application to openshift.
  - from applications panel, click your application 
  - view detail of your applicaiton
    ![](image/cd-18.png)
    - check following component:
      - configmap
      - secret
      - service
      - deployment
      - rolebinding
      - route
  - click sync icon, in sync panel, leave all default and click 'synchronize'
    ![](image/cd-19.png)
  - wait until current sync status change to 'Synced' and last sync result change to 'Sync OK'
    ![](image/cd-20.png)
    - all component change to green icon and don't have yellow icon
* Check Deployment Application in Developer Console
  - back to OpenShift Developer Console, in your topology of project 'userX-superheroes'
  - 'event-statistics' deploy in your project now.
    ![](image/cd-21.png)
    ![](image/cd-22.png)
  - click event-statistics icon, to view deployment information
  - click action menu, select edit resource limits
    ![](image/cd-23.png)
  - in Edit resource limits, check request memory set to 256 Mi and limit memory set to 512 Mi (same with value in overlays/dev/event-statistics.yml)
    ![](image/cd-24.png)
* Test Event-Statistic Demo Applicaiton
  - try super heroes fight! again and agian
    ![](image/cd-25.png)
  - open event-statistics ui, go to your project, click Open URL from event-statistics icon
    ![](image/cd-26.png)
  - view stat change stat auto after you play super heroes fight!
    ![](image/cd-27.png)
    ![](image/cd-28.png)
* View Another view in OpenShift GitOps (ArgoCD)
  - back to your application in Argo CD Console, click your application
  - in the top right of console, try to view another information of your application
    ![](image/cd-29.png)
    - view container deployment information on worker node
    ![](image/cd-30.png)
    - view application network flow 
    ![](image/cd-31.png)
    - view appliation component by type
    ![](image/cd-32.png)
* Test Deployment Application Diff with Deployment Configuration in Git Repository (by OpenShift GitOps)
  - back to openshift developer console, topology, click your event-statistics icon
  - in event-statistics deployment side panel, click Details tab to view information
    ![](image/cd-33.png)
  - try to scale down event-statistics to 0 by click down arrow icon and wait until event-statistics icon in topology change to white circle or pod information in deployment panel change from '1 Pod' to 'Scaled to 0'
    ![](image/cd-34.png)
  - back to Argo CD, your application will change to 'OutOfSync'
  - click to view detail of your applicaiton, view 'OutOfSync' component (for this workshop, diff will occur at deployment object)
    ![](image/cd-36.png)
  - click APP DIFF menu to view detail of diff, click compact diff to focus
    ![](image/cd-37.png)
* Sync to Correct Configuration
  - For sync correct config back to cluster, click sync icon, and click synchronize (leave all default)
    ![](image/cd-38.png)
  - wail until status change to 'Synced', and back to OpenShift Developer Console to view deployment back to 1 Pod
    ![](image/cd-39.png)

    

    
    
    
    

    
    
   