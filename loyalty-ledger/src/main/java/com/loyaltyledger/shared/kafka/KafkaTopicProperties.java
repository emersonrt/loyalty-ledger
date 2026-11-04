package com.loyaltyledger.shared.kafka;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "loyalty.kafka.topics")
public record KafkaTopicProperties(int partitions, short replicas) {
}
