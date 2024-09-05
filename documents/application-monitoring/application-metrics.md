# Application Metrics

![Metrics Dashboard](image/application-metrics/metric.png)

## Metrics are your first sign of trouble

It's important to monitor your application because the first step to fixing a problem is knowing it exists. For example, without monitoring, you may not know when your database server is overloaded or when a new feature has broken something in an older part of the system.

System monitoring tools can help you track many different aspects of your software: CPU utilization, memory footprint, I/O wait times, latency, throughput, errors, and so on. Most applications have at least some metric that can be useful for performance tuning or debugging purposes (although it's easy to get overwhelmed by the number of metrics available). The trick is figuring out which ones are most relevant for your particular situation and understanding how they fit into the big picture.

## User-defined Application Monitoring

In OpenShift Container Platform, cluster components are monitored by scraping metrics exposed through service endpoints. You can also configure metrics collection for user-defined projects.

You can define the metrics that you want to provide for your own workloads by using Prometheus client libraries at the application level.

In OpenShift Container Platform, metrics are exposed through an HTTP service endpoint under the `/metrics` canonical name. You can list all available metrics for a service by running a `curl` query against `http://<endpoint>/metrics`. For instance, you can expose a route to the `prometheus-example-app` example service and then run the following to view all of its available metrics:

```sh
curl http://<example_app_endpoint>/metrics
```

Example output:

```text
HELP http_requests_total Count of all HTTP requests
# TYPE http_requests_total counter
http_requests_total{code="200",method="get"} 4
http_requests_total{code="404",method="get"} 2
# HELP version Version information about this binary
# TYPE version gauge
version{version="v0.1.0"} 1
```

## Understanding the monitoring stack

The OpenShift Container Platform monitoring stack is based on the Prometheus open source project and its wider ecosystem. The monitoring stack includes the following:

* **Default platform monitoring components.** A set of platform monitoring components are installed in the openshift-monitoring project by default during an OpenShift Container Platform installation. This provides monitoring for core OpenShift Container Platform components including Kubernetes services. The default monitoring stack also enables remote health monitoring for clusters. These components are illustrated in the Installed by default section in the following diagram.

* **Components for monitoring user-defined projects.** After optionally enabling monitoring for user-defined projects, additional monitoring components are installed in the openshift-user-workload-monitoring project. This provides monitoring for user-defined projects. These components are illustrated in the User section in the following diagram.

![Metrics Dashboard](image/application-metrics/ocp-monitoring-stack.png)

## Test Application Metrics

1. Review Example Metrics Code of Rest-Heroes
   
   - git repository of Rest-Heroes --> [Rest Heroes](https://github.com/chatapazar/dev-day-2024q3/tree/main/code/rest-heroes)
   - Quarkus use Micrometer Metrics to auto generate default metrics by add dependency (xmicrometer-registry-prometheus) in pom.xml --> [pom.xml](https://raw.githubusercontent.com/chatapazar/dev-day-2024q3/main/code/rest-heroes/pom.xml)
   - Quarkus Micrometer Metrics --> [Quarkus Micrometer](https://quarkus.io/guides/telemetry-micrometer)


2. Test Application Metrics, Back to Topology view, click rest-heroes deployment, click pod in popup panel
   
   ![Application Metrics](image/application-metrics/monitor-12.png)

3. In pod detail, select Terminal tab to access to container
   
   ![Application Metrics](image/application-metrics/monitor-13.png)

4. run command to get application metrics information (in prometheus format)

   Example Command

   ```bash
   curl http://localhost:8080/q/metrics
   ```

   ![Application Metrics](image/application-metrics/monitor-14.png) 

5. review metrics information (prometheus format)

   ![Application Metrics](image/application-metrics/monitor-15.png)  
   
## References

* [Monitoring Overview](https://docs.openshift.com/container-platform/4.11/monitoring/monitoring-overview.html)
