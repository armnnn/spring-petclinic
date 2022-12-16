FROM openjdk:19-jdk-alpine3.16

ADD target/spring-petclinic-2.7.3.jar /usr/bin/app.jar

ENTRYPOINT ["java", "-jar","/usr/bin/app.jar", "--server.port=8080"]

EXPOSE 8080
