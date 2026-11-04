package com.loyaltyledger.ingestion.internal;

import com.loyaltyledger.ingestion.api.IngestionTopics;
import com.loyaltyledger.shared.kafka.KafkaTopicProperties;
import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
class IngestionKafkaConfig {

    @Bean
    NewTopic inboundTopic(KafkaTopicProperties topics) {
        return TopicBuilder.name(IngestionTopics.INBOUND)
                .partitions(topics.partitions())
                .replicas(topics.replicas())
                .build();
    }
}
