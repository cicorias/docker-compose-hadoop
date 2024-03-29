DOCKER_NETWORK = docker-compose-hadoop_default
ENV_FILE = hadoop.env
current_branch := 2.0.0-hadoop3.2.1-java8 #$(shell git rev-parse --abbrev-ref HEAD)
build:
	docker build -t cicorias/hadoop-base:$(current_branch) ./base
	docker build -t cicorias/hadoop-namenode:$(current_branch) ./namenode
	docker build -t cicorias/hadoop-datanode:$(current_branch) ./datanode
	docker build -t cicorias/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t cicorias/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t cicorias/hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t cicorias/hadoop-submit:$(current_branch) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} cicorias/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} cicorias/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal /opt/hadoop-3.2.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} cicorias/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} cicorias/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} cicorias/hadoop-base:$(current_branch) hdfs dfs -rm -r /input
