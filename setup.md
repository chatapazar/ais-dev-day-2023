# Workshop Setup Guide

1. Request OpenShift cluster e.g. **OpenShift Cluster Workshop** with a number of users as needed from RHPDS.

2. Open a terminal on your computer then login to cluster with cluster admin user i.e. **admin** user.

3. Clone this repository to your computer then go to [script](script/) directory.

4. Run [workshop-provisioner.sh](script/workshop-provisioner.sh) script to setup all required operators and software instances.

   ```sh
    ./workshop-provisioner.sh
   ```

   **Following Operators will be installed with *All namespaces* installation mode:**

   * Web Terminal
   * Grafana Operator
   * Dev Workspace Operator 
   * Red Hat OpenShift Dev Spaces
   * Red Hat Streams for Apache Kafka
   * Red Hat build of Apicurio Registry
   * Red Hat OpenShift distributed tracing platform
   * Red Hat build of OpenTelemetry
   * Red Hat Cluster Logging
   * Red Hat Loki

   **Following Applications will be set up using CRD:**

   * Dev Spaces (Eclipse Che) in **redhat-openshift-devspaces** project

4.5 if you found error Dev Workspace Operator 0.30  

  * https://access.redhat.com/solutions/7084768 (need restart controller pod to take effect)

5. Install Web Terminal Operator via OpenShift web console then run these commands to custom the tooling image.

   For some reasons, the web terminal icon doesn't show in OpenShift web console if we install Web Terminal operator via CLI but the issue is gone if we install it via OpenShift web console. That's weird!

   ```sh
   cd script
   oc annotate devworkspacetemplates.workspace.devfile.io web-terminal-tooling 'web-terminal.redhat.com/unmanaged-state=true' -n openshift-operators
   oc patch devworkspacetemplates.workspace.devfile.io web-terminal-tooling --type=merge --patch-file=../manifest/web-terminal-tooling.json -n openshift-operators
   ```

6. Export lab user password and cluster admin password (the passwords should be there in the mail sent from RHDP). Then run [lab-user-provisioner.sh](script/lab-user-provisioner.sh) script with number of lab users as the script argument.

   For example, provisioning 5 lab users:

   ```sh
   export USER_PASSWORD=H3x8GWJZPtxxU8xp
   export ADMIN_PASSWORD=Ysrun6PzuUrL5h3q
   ./lab-user-provisioner.sh 5
   ```

   **Following projects/namespaces will be created for each user:**
   * user*X*-devspaces
   * user*X*-super-heroes
   * user*X*-monitoring
