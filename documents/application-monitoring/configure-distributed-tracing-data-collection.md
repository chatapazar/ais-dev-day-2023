# Configure OpenShift Distributed Tracing Data Collection

## Deploy distributed tracing data collection

1. Click on the book icon, to add application from Developer Catalog then type `collector` in the search box. Select **OpenTelemetry Collector** and click **Create** button.

    ![Deploy OpenTelemetry collector](image/distrubuted-tracing/deploy-4.png)

2. Switch to **YAML view**, copy following YAML snippet to the editor. :exclamation: **DO NOT FORGET** to change `userX` in line `16` to your user, then click **Create** button.

   *YAML snippet:*



   ```yaml
   apiVersion: opentelemetry.io/v1alpha1
   kind: OpenTelemetryCollector
   metadata:
     name: otel
   spec:
     mode: deployment
     config: |
       receivers:
         otlp:
           protocols:
             grpc: {}
             http: {}
       processors:
       exporters:
         otlp:
           endpoint: jaeger-collector-headless.userX-super-heroes.svc.cluster.local:4317
           tls:
             insecure: true
       service:
         pipelines:
           traces:
             receivers: [otlp]
             processors: []
             exporters: [otlp]
    ```


    ![Deploy OpenTelemetry collector](image/distrubuted-tracing/deploy-5.png)

3. Wait for a monent you'll see OpenTelemetry collector instance get deployed.

    ![Deploy OpenTelemetry collector](image/distrubuted-tracing/deploy-6.png)

## How to implement OpenTelemetry in Application

1. Example OpenTelemetry Configuration in Quarkus --> https://github.com/chatapazar/dev-day-2024q3/blob/main/code/rest-heroes/src/main/resources/application.yml
   
   Example Config
   ```yaml
   opentelemetry:
     tracer:
       quarkus.opentelemetry.propagators: b3
       resource-attributes: "app=${quarkus.application.name},application=heroes-service,system=quarkus-super-heroes"
       exporter:
         otlp:
           endpoint: http://localhost:4317
   ```

2. Example OpenTelemetry Configuration for JDBC --> https://github.com/chatapazar/dev-day-2024q3/blob/main/code/rest-villains/src/main/resources/application.properties
   
   Example Config
   ```property
   # OpenTelemetry
   quarkus.opentelemetry.propagators=b3
   quarkus.opentelemetry.tracer.resource- attributes=app=${quarkus.application.name},application=villains-service,system=quarkus-super-heroes
   quarkus.opentelemetry.tracer.exporter.otlp.endpoint=http://localhost:4317
   quarkus.datasource.jdbc.driver=io.opentelemetry.instrumentation.jdbc.OpenTelemetryDriver
   ```

3. Example OpenTelemetry with Kafka Client --> https://github.com/chatapazar/dev-day-2024q3/blob/main/code/rest-fights/src/main/java/io/quarkus/sample/superheroes/fight/service/FightService.java
   
   Example Code
   ```java
   ...
     @WithSpan("FightService.persistFight")
	Uni<Fight> persistFight(@SpanAttribute("arg.fight") Fight fight) {
    Log.debugf("Persisting a fight: %s", fight);
		return Fight.persist(fight)
      .replaceWith(fight)
      .map(this.fightMapper::toSchema)
      .invoke(f -> this.emitter.send(Message.of(f, Metadata.of(TracingMetadata.withCurrent(Context.current())))))
      .replaceWith(fight);
	}
   ...

   ```

## What have you learnt?

How to deploy distributed tracing data collection (based on [OpenTelemetry](https://opentelemetry.io/) open source project).
