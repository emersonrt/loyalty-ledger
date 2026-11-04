package com.loyaltyledger.campaigns.internal;

import com.loyaltyledger.campaigns.api.CampaignTopics;
import com.loyaltyledger.shared.kafka.KafkaTopicProperties;
import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
class CampaignKafkaConfig {

    @Bean
    NewTopic campaignsTopic(KafkaTopicProperties topics) {
        return TopicBuilder.name(CampaignTopics.CHANGED)
                .partitions(topics.partitions())
                .replicas(topics.replicas())
                .build();
    }
}
