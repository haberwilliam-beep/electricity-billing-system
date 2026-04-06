package com.electricity;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@TestPropertySource(properties = {
    "spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;MODE=MySQL;NON_KEYWORDS=VALUE",
    "spring.datasource.driver-class-name=org.h2.Driver",
    "spring.datasource.username=sa",
    "spring.datasource.password=",
    "spring.sql.init.mode=always",
    "spring.sql.init.schema-locations=classpath:schema.sql",
    "mybatis.mapper-locations=classpath:mapper/*.xml",
    "mybatis.configuration.map-underscore-to-camel-case=true"
})
class ElectricityBillingApplicationTests {

    @Test
    void contextLoads() {
        // Verify Spring context loads successfully
    }
}
