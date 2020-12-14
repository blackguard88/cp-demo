#!/bin/bash

HEADER="Content-Type: application/json"
export REPLICATOR_NAME=${REPLICATOR_NAME:-replicate-topic-to-ccloud}

DATA=$( cat << EOF
{
  "name": "${REPLICATOR_NAME}",
  "config": {
    "connector.class": "io.confluent.connect.replicator.ReplicatorSourceConnector",
    "topic.whitelist": "wikipedia.parsed",
    "topic.rename.format": "\${topic}.ccloud.replica",
    "topic.sync": "false",
    "key.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "${SCHEMA_REGISTRY_URL}",
    "value.converter.basic.auth.credentials.source": "${BASIC_AUTH_CREDENTIALS_SOURCE}",
    "value.converter.schema.registry.basic.auth.user.info": "${SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO}",
    "src.value.converter": "io.confluent.connect.avro.AvroConverter",
    "src.value.converter.schema.registry.url": "https://schemaregistry:8085",
    "src.value.converter.schema.registry.ssl.truststore.location": "/etc/kafka/secrets/kafka.client.truststore.jks",
    "src.value.converter.schema.registry.ssl.truststore.password": "confluent",
    "src.value.converter.basic.auth.credentials.source": "USER_INFO",
    "src.value.converter.basic.auth.user.info": "connectorSA:connectorSA",
    "dest.kafka.bootstrap.servers": "${BOOTSTRAP_SERVERS}",
    "dest.kafka.security.protocol": "SASL_SSL",
    "dest.kafka.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"${CLOUD_KEY}\" password=\"${CLOUD_SECRET}\";",
    "dest.kafka.sasl.mechanism": "PLAIN",
    "dest.topic.replication.factor": 3,
    "confluent.topic.replication.factor": 3,
    "src.kafka.bootstrap.servers": "kafka1:10091",
    "src.kafka.security.protocol": "SASL_SSL",
    "src.kafka.ssl.key.password": "confluent",
    "src.kafka.ssl.truststore.location": "/etc/kafka/secrets/kafka.client.truststore.jks",
    "src.kafka.ssl.truststore.password": "confluent",
    "src.kafka.ssl.keystore.location": "/etc/kafka/secrets/kafka.client.keystore.jks",
    "src.kafka.ssl.keystore.password": "confluent",
    "src.kafka.sasl.login.callback.handler.class": "io.confluent.kafka.clients.plugins.auth.token.TokenUserLoginCallbackHandler",
    "src.kafka.sasl.jaas.config": "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required username=\"connectorSA\" password=\"connectorSA\" metadataServerUrls=\"https://kafka1:8091,https://kafka2:8092\";",
    "src.kafka.sasl.mechanism": "OAUTHBEARER",
    "src.consumer.group.id": "connect-replicator",
    "offset.timestamps.commit": "false",
    "producer.override.bootstrap.servers": "${BOOTSTRAP_SERVERS}",
    "producer.override.security.protocol": "SASL_SSL",
    "producer.override.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"${CLOUD_KEY}\" password=\"${CLOUD_SECRET}\";",
    "producer.override.sasl.mechanism": "PLAIN",
    "producer.override.sasl.login.callback.handler.class": "org.apache.kafka.common.security.authenticator.AbstractLogin\$DefaultLoginCallbackHandler",
    "consumer.override.sasl.jaas.config": "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required username=\"connectorSA\" password=\"connectorSA\" metadataServerUrls=\"https://kafka1:8091,https://kafka2:8092\";",
    "src.kafka.timestamps.producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.security.protocol": "SASL_SSL",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.bootstrap.servers": "kafka1:10091",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.ssl.key.password": "confluent",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.ssl.truststore.location": "/etc/kafka/secrets/kafka.client.truststore.jks",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.ssl.truststore.password": "confluent",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.ssl.keystore.location": "/etc/kafka/secrets/kafka.client.keystore.jks",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.ssl.keystore.password": "confluent",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.sasl.login.callback.handler.class": "io.confluent.kafka.clients.plugins.auth.token.TokenUserLoginCallbackHandler",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.sasl.jaas.config": "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required username=\"connectorSA\" password=\"connectorSA\" metadataServerUrls=\"https://kafka1:8091,https://kafka2:8092\";",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.sasl.mechanism": "OAUTHBEARER",

    "producer.override.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor",
    "producer.override.confluent.monitoring.interceptor.security.protocol": "SASL_SSL",
    "producer.override.confluent.monitoring.interceptor.bootstrap.servers": "kafka1:10091",
    "producer.override.confluent.monitoring.interceptor.ssl.key.password": "confluent",
    "producer.override.confluent.monitoring.interceptor.ssl.truststore.location": "/etc/kafka/secrets/kafka.client.truststore.jks",
    "producer.override.confluent.monitoring.interceptor.ssl.truststore.password": "confluent",
    "producer.override.confluent.monitoring.interceptor.ssl.keystore.location": "/etc/kafka/secrets/kafka.client.keystore.jks",
    "producer.override.confluent.monitoring.interceptor.ssl.keystore.password": "confluent",
    "producer.override.confluent.monitoring.interceptor.sasl.login.callback.handler.class": "io.confluent.kafka.clients.plugins.auth.token.TokenUserLoginCallbackHandler",
    "producer.override.confluent.monitoring.interceptor.sasl.jaas.config": "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required username=\"connectorSA\" password=\"connectorSA\" metadataServerUrls=\"https://kafka1:8091,https://kafka2:8092\";",
    "producer.override.confluent.monitoring.interceptor.sasl.mechanism": "OAUTHBEARER",
    "src.consumer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor",
    "src.consumer.confluent.monitoring.interceptor.security.protocol": "SASL_SSL",
    "src.consumer.confluent.monitoring.interceptor.bootstrap.servers": "kafka1:10091",
    "src.consumer.confluent.monitoring.interceptor.ssl.key.password": "confluent",
    "src.consumer.confluent.monitoring.interceptor.ssl.truststore.location": "/etc/kafka/secrets/kafka.client.truststore.jks",
    "src.consumer.confluent.monitoring.interceptor.ssl.truststore.password": "confluent",
    "src.consumer.confluent.monitoring.interceptor.ssl.keystore.location": "/etc/kafka/secrets/kafka.client.keystore.jks",
    "src.consumer.confluent.monitoring.interceptor.ssl.keystore.password": "confluent",
    "src.consumer.confluent.monitoring.interceptor.sasl.login.callback.handler.class": "io.confluent.kafka.clients.plugins.auth.token.TokenUserLoginCallbackHandler",
    "src.consumer.confluent.monitoring.interceptor.sasl.jaas.config": "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required username=\"connectorSA\" password=\"connectorSA\" metadataServerUrls=\"https://kafka1:8091,https://kafka2:8092\";",
    "src.consumer.confluent.monitoring.interceptor.sasl.mechanism": "OAUTHBEARER",
    "src.consumer.group.id": "connect-replicator",
    "tasks.max": "1",
    "provenance.header.enable": "true"
  }
}
EOF
)

docker-compose exec connect curl -X POST -H "${HEADER}" --data "${DATA}" --cert /etc/kafka/secrets/connect.certificate.pem --key /etc/kafka/secrets/connect.key --tlsv1.2 --cacert /etc/kafka/secrets/snakeoil-ca-1.crt -u connectorSubmitter:connectorSubmitter https://connect:8083/connectors
