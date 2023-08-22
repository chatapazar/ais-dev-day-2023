package io.quarkus.sample.superheroes.villain.config;

import java.util.Arrays;

import io.micrometer.core.instrument.Tag;
import io.micrometer.core.instrument.config.MeterFilter;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import io.quarkus.micrometer.runtime.MeterFilterConstraint;
import javax.inject.Singleton;
import javax.enterprise.inject.Produces;

@Singleton
public class MeterConfig {

    /** Define common tags that apply only to a Prometheus Registry */
    @Produces
    @Singleton
    @MeterFilterConstraint(applyTo = PrometheusMeterRegistry.class)
    public MeterFilter configurePrometheusRegistries() {
        return MeterFilter.commonTags(Arrays.asList(
                Tag.of("application", "rest-villains")));
    }

}