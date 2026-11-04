package com.loyaltyledger;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class LoyaltyLedgerApplication {

    public static void main(String[] args) {
        SpringApplication.run(LoyaltyLedgerApplication.class, args);
    }
}
