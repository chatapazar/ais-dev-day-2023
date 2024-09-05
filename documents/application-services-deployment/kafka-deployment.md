# Red Hat Streams of Apache Kafka Deployment

Apache Kafka has become the streaming technology of choice for this type of replication. Kafka is prized by these teams for performance, scalability, and ability to replay streams so that the teams can reset their intermediate stores to any point in time.

The Red Hat® Streams of Apache Kafka component is a massively scalable, distributed, and high-performance data streaming platform based on the Apache Kafka project. It offers a distributed backbone that allows microservices and other applications to share data with high throughput and low latency.

As more applications move to Kubernetes and Red Hat OpenShift® , it is increasingly important to be able to run the communication infrastructure on the same platform. Red Hat OpenShift, as a highly scalable platform, is a natural fit for messaging technologies such as Kafka. The Red Hat Streams of Apache Kafka component makes running and managing Apache Kafka OpenShift native through the use of powerful operators that simplify the deployment, configuration, management, and use of Apache Kafka on Red Hat OpenShift.

The Red Hat Streams of Apache Kafka component is part of the Red Hat AMQ family, which also includes the AMQ broker, a longtime innovation leader in Java™ Message Service (JMS) and polyglot messaging, as well as the AMQ interconnect router, a wide-area, peer-to-peer messaging solution.

The **Fight** and **Statistics** microservices will be interacting with Kafka broker as the architecture diagram below. So, we have to setup the broker for the microservices before we're going to deploy them.

![Architecture](image/kafka-deployment/architecture.png)

## Setup Kafka cluster

1. Click on the book icon, to add application from Developer Catalog then type `kafka` in the search box. Select **Kafka** and click **Create** button.

    ![Add Kafka broker](image/kafka-deployment/kafka-deployment-1.png)

2. Enter `fights` to the **Name** field then click **Create** button.

    ![Add Kafka broker](image/kafka-deployment/kafka-deployment-2.png)

3. Wait for a monent (2-3 minutes) you'll see Kafka cluster get deployed. Who says setup Kafka cluster is hard? :smirk:

    ![Add Kafka broker](image/kafka-deployment/kafka-deployment-3.png)

4. Create sample kafka topic to test kafka cluster, In Topology view, click Add to Project icon (book icon), type topic in popup panel and select Kafka Topic, click Create
   
    ![Create Kafka Topic](image/kafka-deployment/kafka-1.png)

5. In create KafkaTopic, change configure via from view to yaml view, 
   
   - **set labels of strimizi.io/cluster to** `fights`
   - click create
   
    ![Edit Kafka Cluster Name](image/kafka-deployment/kafka-2.png)

6. Check Kafka Topic by Search view, Click Search from left menu and set resources filter to KafkaTopic, view my-topic in search result

    ![Search Kafka Topic](image/kafka-deployment/kafka-3.png)

7. Test Kafka with Example Producer Image, Deploy kafka producer with yaml, click plus icon at the top of OpenShift Console and input below yaml in Import YAML and click create button

    ```yaml   
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: quick-java-kafka-producer
      name: quick-java-kafka-producer
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: quick-java-kafka-producer
      template:
        metadata:
          labels:
            app: quick-java-kafka-producer
        spec:
          containers:
            - name: quick-java-kafka-producer
              image: quay.io/strimzi-examples/java-kafka-producer:latest
              env:
                - name: STRIMZI_TOPIC
                  value: my-topic
                - name: STRIMZI_DELAY_MS
                  value: "1000"
                - name: STRIMZI_LOG_LEVEL
                  value: "INFO"
                - name: STRIMZI_MESSAGE_COUNT
                  value: "1000000"
                - name: KAFKA_BOOTSTRAP_SERVERS
                  value: fights-kafka-bootstrap:9092
                - name: KAFKA_KEY_SERIALIZER
                  value: "org.apache.kafka.common.serialization.StringSerializer"
                - name: KAFKA_VALUE_SERIALIZER
                  value: "org.apache.kafka.common.serialization.StringSerializer"
    ```

    ![Deploy kafka producer](image/kafka-deployment/kafka-4.png)

8. Back to Topology view, click quick-java-kafka-producer deployment and select Resources Tab in popup panel, click View logs from running pod
   
    ![View kafka producer log](image/kafka-deployment/kafka-5.png)

9.  Check producer log, kafka producer client try to send message to kafka broker
    
    ![View kafka producer log](image/kafka-deployment/kafka-6.png)

10. Test Kafka with Example Consumer Image, Deploy kafka consumer with yaml, click plus icon at the top of OpenShift Console and input below yaml in Import YAML and click create button

    ```yaml   
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: quick-java-kafka-consumer
      name: quick-java-kafka-consumer
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: quick-java-kafka-consumer
      template:
        metadata:
          labels:
            app: quick-java-kafka-consumer
        spec:
          containers:
            - name: quick-java-kafka-consumer
              image: quay.io/strimzi-examples/java-kafka-consumer:latest
              env:
                - name: STRIMZI_TOPIC
                  value: my-topic
                - name: STRIMZI_LOG_LEVEL
                  value: "INFO"
                - name: STRIMZI_MESSAGE_COUNT
                  value: "1000000"
                - name: KAFKA_BOOTSTRAP_SERVERS
                  value: fights-kafka-bootstrap:9092
                - name: KAFKA_GROUP_ID
                  value: test-group
                - name: KAFKA_KEY_DESERIALIZER
                  value: "org.apache.kafka.common.serialization.StringDeserializer"
                - name: KAFKA_VALUE_DESERIALIZER
                  value: "org.apache.kafka.common.serialization.StringDeserializer"
    ```

    ![Deploy kafka consumer](image/kafka-deployment/kafka-7.png)

11. Back to Topology view, click quick-java-kafka-consumer deployment and select Resources Tab in popup panel, click View logs from running pod
   
    ![View kafka consumer log](image/kafka-deployment/kafka-8.png)

12. Check consumer log, kafka producer client try to receive message from kafka broker
    
    ![View kafka consumer log](image/kafka-deployment/kafka-9.png)

13. Review source code of Kafka Client at [client-examples](https://github.com/strimzi/client-examples)

   - producer example source code at [KafkaProducerExample.java](https://raw.githubusercontent.com/strimzi/client-examples/main/java/kafka/producer/src/main/java/io/strimzi/kafka/producer/KafkaProducerExample.java)
   
   - consumer example source code at [KafkaConsumerExample.java](https://raw.githubusercontent.com/strimzi/client-examples/main/java/kafka/consumer/src/main/java/io/strimzi/kafka/consumer/KafkaConsumerExample.java)

14. Stop kafka producer client, click quick-java-kafka-producer deployment, select Details tab on popup panel and click scale down to 0 
    
    ![Stop kafka producer](image/kafka-deployment/kafka-10.png)

15. Stop kafka consumer client, click quick-java-kafka-consumer deployment, select Details tab on popup panel and click scale down to 0 
    
    ![Stop kafka consumer](image/kafka-deployment/kafka-11.png)

16. View kafka information with Kafdrop, right click on Topology view, select Add to Project --> Container Image
    
    ![Deploy kafdrop image](image/kafka-deployment/kafka-12.png)

17. In Deploy Image page, 
    
    - select image name from external registry
    - input `obsidiandynamics/kafdrop`
    - set Runtime icon to `amq`

    ![Deploy Image](image/kafka-deployment/kafka-13.png)

18. Set General Information for deployment
    
    - select Create application
    - set applicaton name to `kafdrop`
    - set name to `kafdrop`
    - select resource type to `Deployment`

    ![Deploy Image](image/kafka-deployment/kafka-14.png)

19. In advanced deployment option
    
    - Set Environment variables
    - set name to `KAFKA_BROKERCONNECT`
    - set value to `fights-kafka-bootstrap:9092`
    - leave all default, click Create

    ![Deploy Image](image/kafka-deployment/kafka-16.png)

20. After Deploy complete, click open url
    
    ![Deploy Image](image/kafka-deployment/kafka-18.png)

21. view kafka cluster overview, broker information, topics
    
    ![Deploy Image](image/kafka-deployment/kafka-19.png)

    ![Deploy Image](image/kafka-deployment/kafka-20.png)

    ![Deploy Image](image/kafka-deployment/kafka-21.png)


## What have you learnt?

How to set up Kafka cluster using Red Hat Streams for Apache Kafka (based on [Strimzi](https://strimzi.io/) open source project).


