# Workshop Setup Guide

1. Request OpenShift cluster e.g. **OpenShift 4.11 Workshop** with a number of users as needed from RHPDS.

2. Open a terminal on your computer then login to cluster with cluster admin user i.e. **opentlc-mgr** user.

3. Clone this repository to your computer then go to [script](script/) directory.

4. Run [workshop-provisioner.sh](script/workshop-provisioner.sh) script to setup all required operators and software instances.

   ```sh
    ./workshop-provisioner.sh
   ```

5. Run [lab-user-provisioner.sh](script/lab-user-provisioner.sh) with number of users as the script argument.

   For example:

   ```sh
    ./lab-user-provisioner.sh 40
   ```
