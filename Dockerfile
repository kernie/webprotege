FROM maven:3.6.0-jdk-11-slim AS build

RUN apt-get update && \
    apt-get install -y git mongodb vim nano

COPY . /webprotege

WORKDIR /webprotege

RUN mkdir -p /data/db \
    && mongod --fork --syslog 
#   && MAVEN_OPTS=-Xmx512m mvn -X clean package -DskipTests -Dgwt.localWorkers=1 

FROM tomcat:8-jre11-slim

RUN rm -rf /usr/local/tomcat/webapps/* \
    && mkdir -p /srv/webprotege \
    && mkdir -p /usr/local/tomcat/webapps/ROOT

WORKDIR /usr/local/tomcat/webapps/ROOT

#COPY --from=build /webprotege/webprotege-cli/target/webprotege-cli-4.0.0-beta-3-SNAPSHOT.jar /webprotege-cli.jar
#COPY --from=build /webprotege/webprotege-server/target/webprotege-server-4.0.0-beta-3-SNAPSHOT.war ./webprotege.war
ADD https://github.com/protegeproject/webprotege/releases/download/v4.0.2/webprotege-server-4.0.2.war ./webprotege.war
ADD https://github.com/protegeproject/webprotege/releases/download/v4.0.2/webprotege-cli-4.0.2.jar /webprotege-cli.jar

RUN unzip webprotege.war \
    && rm webprotege.war
