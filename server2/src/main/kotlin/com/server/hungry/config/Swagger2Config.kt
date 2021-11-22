package com.server.hungry.config

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.EnableWebMvc
import springfox.documentation.builders.ApiInfoBuilder
import springfox.documentation.builders.PathSelectors
import springfox.documentation.builders.RequestHandlerSelectors
import springfox.documentation.service.ApiInfo
import springfox.documentation.service.Contact
import springfox.documentation.spi.DocumentationType
import springfox.documentation.spring.web.plugins.Docket
import springfox.documentation.swagger2.annotations.EnableSwagger2

/**
 * Swagger2Config
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-20
 */

@Configuration
@EnableSwagger2
@EnableWebMvc
class Swagger2Config {

    @Bean
    fun commonApi(): Docket {
        return Docket(DocumentationType.SWAGGER_2)
            .apiInfo(this.metaInfo())
            .select()
            .apis(RequestHandlerSelectors.any())
            .paths(PathSelectors.any())
            .build()
    }

    private fun metaInfo(): ApiInfo {
        return ApiInfoBuilder()
            .title("Hungry API")
            .description("Hungry API 문서입니다.")
            .version("1.0")
            .contact(
                Contact(
                    "moseoh",
                    "https://github.com/azqazq195",
                    "azqazq195@gmail.com"
                )
            )
            .build()
    }
}
