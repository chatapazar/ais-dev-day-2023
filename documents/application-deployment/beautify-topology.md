# Beautify The Topology View

Until now you've deployed most of microservices except the **Statustics** and its UI services. By the way, the interesting lab was deploying the **Fight** microservice that at the end you can see the visual connectors (arrow lines) in the Topoligy view. That's cool, isn't it?

The visual connector don't represent actual network connections among services nor impact the services communication neither when we add connectors to or remove from the entities. The visual connector just provide better understanding of application overview architecture and relationship of services in the application. Technically, it's just one of the `annotations` elements. See [Well-Known Labels, Annotations and Taints](https://kubernetes.io/docs/reference/labels-annotations-taints/) for more details.

Though, in Topology view right now, the diagram is not yet completed and we should add the missing visual connectors.  Let's get it done!

