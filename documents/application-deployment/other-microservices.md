# Other Microservices

You've learnt how to deploy application via OpenShift Web Console in the previous section. Now, for the sake of speed and time saving, we're going to use a script to deploy the rest of microservices as following:

- Villain microservice
- Fight microservice
- Statistics microservice
- Super Hero UI microservice

If you're curious what the script does, see the code [here](../../script/installation.sh).

## Deploy application using script

1. In the Web Terminal, run following commands to deploy the microservices. Wait for a few seconds you should see all of the microservices get deployed.

    ```sh
    ./installation.sh app $(oc whoami)-super-heroes
    ```

    ![Deploy application](image/other-microservices/app-deploy-1.png)

2. Wait until all microservices up and running (all pods has blue ring around) then click on arrow icon of `ui-super-heroes` pod to open the Super Heroes web application.

    ![Deploy application](image/other-microservices/app-deploy-2.png)

3. Play around the application UI by click on **NEW FIGHTERS** then **FIGHT**  to simulate fighting between hero and villain repeatly.

    ![Deploy application](image/other-microservices/app-deploy-3.png)

4. Go back to OpenShift web console then open the `event-statistics` web page to see fight statistics.

    ![Deploy application](image/other-microservices/app-deploy-4.png)

5. You should be able to see the result realtime. These fignt information are fetched from Kafka topic.

    ![Deploy application](image/other-microservices/app-deploy-5.png)
