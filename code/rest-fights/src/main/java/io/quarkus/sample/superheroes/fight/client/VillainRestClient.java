package io.quarkus.sample.superheroes.fight.client;
import static javax.ws.rs.core.MediaType.*;


import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

import org.eclipse.microprofile.rest.client.annotation.RegisterClientHeaders;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

import io.smallrye.mutiny.Uni;

@Path("/api/villains")
@Produces(APPLICATION_JSON)
@RegisterRestClient(configKey = "villain-client")
// @RegisterClientHeaders(CustomClientHeaders.class)
@RegisterClientHeaders
interface VillainRestClient {

    @GET
	@Path("/random")
	Uni<Villain> findRandomVillain();

    @GET
    @Path("/hello")
    @Produces(TEXT_PLAIN)
    Uni<String> hello();
}
