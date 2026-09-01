package cl.duoc.jv0101.caso02.postulaciones.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Postulaciones API")
                        .version("1.0.0")
                        .description("Microservicio Postulaciones del caso caso02 - TalentoYa."));
    }
}
