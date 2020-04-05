[![Build Status](https://travis-ci.com/Mahdi89/vector-ML.svg?branch=master)](https://travis-ci.com/Mahdi89/vector-ML)

## Vector ML project

A data streaming platform based on Kafka for AI services

This project has three main parts:

Part 1) Trains a CNN on fashion mnist dataset and saves the trained model.
Part 2) Deploys a TensorFlow Model Server and Runs the saved model from `part 1` as a service with `gRPC` interface.
Part 3) Populates a Kafka cluster and deploys a service to make `gPRC` calls to the deployed service in `part 2`.

Requirements

* Java 8
* Docker
* Conda
* tensorflow-2

Part 1:

First off, run the following to create a conda env and activate it:

```
conda env create -f environment.yml
conda actiavte env
```

Run `make install` to install fmnist library
and by running `make test` a CNN model will be trained and saved into `/tmp/1`

Part 2:

Use the following to deploy a prebuilt tensorflow service

```
# pull and start the prebuilt container, forward port 9000
docker run -it -p 9000:9000 tgowda/inception_serving_tika

# copy the trained model to the docker space 
docker cp /tmp/1 tgowda/inception_serving_tika:/server

# Inside the container, start tensorflow service
root@8311ea4e8074:/# /serving/server.sh
```

Part 3:

Set up kafka 
https://tecadmin.net/install-apache-kafka-ubuntu/

```
kafka-topics --zookeeper localhost:2181 --create --topic ImageInputTopic --partitions 3 --replication-factor 1
            
kafka-topics --zookeeper localhost:2181 --create --topic ImageOutputTopic --partitions 3 --replication-factor 1

# Deploy a Kafka Streams app that constantly read from `ImageInputTopic`, makes a TF service call and publishes the results to `ImageOutputTopic`.

# The application is selected from Confluent Inc.

mvn clean package 

java -cp target/tensorflow-serving-java-grpc-kafka-streams-1.0-jar-with-dependencies.jar com.github.megachucky.kafka.streams.machinelearning.Kafka_Streams_TensorFlow_Serving_gRPC_Example

echo -e "data/example.jpg" | kafkacat -b localhost:9092 -P -t ImageInputTopic
kafka-console-consumer --bootstrap-server localhost:9092 --topic ImageOutputTopic --from-beginning
```
