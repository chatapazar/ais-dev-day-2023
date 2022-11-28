# Trace application transaction

## Tracing application information

1. Open Super Heroes main UI web then start a random fight.

   ![Application transaction tracing](image/distrubuted-tracing/otel-1.png)

2. Switch back to OpenShift web console, then open Jaeger web console by click on arrow icon from **jaeger** entity.

   ![Application transaction tracing](image/distrubuted-tracing/otel-2.png)

3. Click **Log in with OpenShift** button.

   ![Application transaction tracing](image/distrubuted-tracing/otel-3.png)

4. Log in with your username and password.

   ![Application transaction tracing](image/distrubuted-tracing/otel-4.png)

5. Click **Allow selected permissions** button.

   ![Application transaction tracing](image/distrubuted-tracing/otel-5.png)

6. Select following options then click **Find Traces** button.

    - **Service:** `rest-fights`
    - **Operation:** `/api/fights/randomfighters`

   ![Application transaction tracing](image/distrubuted-tracing/otel-6.png)

7. Click on one of the Traces result.

   ![Application transaction tracing](image/distrubuted-tracing/otel-7.png)

8. You'll see the trace from the **Fight** (rest-fights) service all the way down to the **Villain** (rest-villains) service.

   ![Application transaction tracing](image/distrubuted-tracing/otel-8.png)

9. Expand the **Tags** section to see details of each span e.g. data, configurations, context information etc.

   ![Application transaction tracing](image/distrubuted-tracing/otel-9.png)

## Trace a fight transaction

1. Select **rest-fights** service and the **/api/fights** operation. Click **Find Traces** then click on the first trace from result.

   ![Application transaction tracing](image/distrubuted-tracing/otel-10.png)

2. Click on **rest-fights FightService.performFight** then click **Tags** to see API call input.

   ![Application transaction tracing](image/distrubuted-tracing/otel-11.png)

3. Note the name of fighters in the input request.

   ![Application transaction tracing](image/distrubuted-tracing/otel-12.png)

4. Switch to Super Heros main UI, then compare the fighter names you see in Jaeger to the fighter names of the last fight in Super Heros main UI.

   ![Application transaction tracing](image/distrubuted-tracing/otel-13.png)

5. Go back to Jarger web console and expore more spans. You'll see the trace to Kafka topic as well.

   ![Application transaction tracing](image/distrubuted-tracing/otel-14.png)

## What have you learnt?

How to use Jaeger to trace application transaction.
