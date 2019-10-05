FROM maven:3-jdk-8 as builder
MAINTAINER SpringTeam
WORKDIR /root/
COPY apps /root/apps
WORKDIR /root/apps
RUN mvn clean package

FROM tomcat:8.5
COPY --from=builder /root/apps/target/demo.war /usr/local/tomcat/webapps/demo.war
RUN apt-get update && \
  apt-get install -y \
    net-tools \
    tree \
    vim && \
  rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get purge
RUN echo "export JAVA_OPTS=\"-Dapp.env=staging\"" > /usr/local/tomcat/bin/setenv.sh
EXPOSE 8080
CMD ["catalina.sh", "run"]
