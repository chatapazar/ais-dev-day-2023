# Workshop Setup Guide

1. Request OpenShift cluster e.g. **OpenShift 4.11 Workshop** with a number of users as needed from RHPDS.

2. Open a terminal on your computer then login to cluster with cluster admin user i.e. **opentlc-mgr** user.

3. Clone this repository to your computer then go to [script](script/) directory.

4. Run [workshop-provisioner.sh](script/workshop-provisioner.sh) script to setup all required operators and software instances.

   ```sh
    ./workshop-provisioner.sh
   ```

   **Following Operators will be installed with *All namespaces* installation mode:**

   * Gitea Operator
   * Web Terminal
   * Dev Workspace Operator
   * Red Hat OpenShift Dev Spaces
   * Red Hat OpenShift Service Mesh
   * Red Hat Integration - AMQ Streams
   * Red Hat OpenShift GitOps
   * Red Hat OpenShift distributed tracing platform
   * Red Hat OpenShift distributed tracing data collection

   **Following Applications will be set up using CRD:**

   * Gitea in **gitea** project
   * Dev Spaces (Eclipse Che) in **redhat-openshift-devspaces** project

   **Following Applications will be installed:**

   * Sonatype Nexus Repository Manager 3 OSS in **nexus** project

5. Export lab user password and cluster admin password (the passwords should be there in the mail sent from RHPDS). Then run [lab-user-provisioner.sh](script/lab-user-provisioner.sh) script with number of lab users as the script argument.

   For example, provisioning 40 lab users:

   ```sh
    export USER_PASSWORD=openshift
    export ADMIN_PASSWORD=r3dh4t1!
    ./lab-user-provisioner.sh 5
   ```

   **Following projects/namespaces will be created for each user:**
   * user*X*-devspaces
   * user*X*-superheroes
   * user*X*-istio-system

   **Following Operators will be installed with *A specific namespace* installation mode:**

   * Grafana Operator
