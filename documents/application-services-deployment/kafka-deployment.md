# AMQ Streams (Kafka) Deployment

The **Fight** and **Statistics** microservices will be interacting with Kafka broker as the architecture diagram below. So, we have to setup the broker for the microservices before we're going to deploy them.

![Architecture](image/kafka-deployment/architecture.png)

## Setup Kafka cluster

1. Click on the book icon, to add application from Developer Catalog then type `kafka` in the search box. Select **Kafka** and click **Create** button.

    ![Add Kafka broker](image/kafka-deployment/kafka-deployment-1.png)

2. Enter `fights` to the **Name** field then click **Create** button.

    ![Add Kafka broker](image/kafka-deployment/kafka-deployment-2.png)

3. Wait for a monent you'll see Kafka cluster get deployed. Who says setup Kafka cluster is hard? :smirk:

    ![Add Kafka broker](image/kafka-deployment/kafka-deployment-3.png)

## What have you learnt?

How to set up Kafka cluster using AMQ Streams (based on [Strimzi](https://strimzi.io/) open source project).
