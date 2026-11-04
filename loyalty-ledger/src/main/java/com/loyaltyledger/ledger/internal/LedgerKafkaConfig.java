package com.loyaltyledger.ledger.internal;

import com.loyaltyledger.ledger.api.LedgerTopics;
import com.loyaltyledger.shared.kafka.KafkaTopicProperties;
import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

/**
 * {@link LedgerTopics#TRANSACTION_POSTED} is not created here: the Debezium connector creates it and produces to it.
 */
@Configuration
class LedgerKafkaConfig {

    @Bean
    NewTopic ledgerCommandsTopic(KafkaTopicProperties topics) {
        return TopicBuilder.name(LedgerTopics.COMMANDS)
                .partitions(topics.partitions())
                .replicas(topics.replicas())
                .build();
    }
}
