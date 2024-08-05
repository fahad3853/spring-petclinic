# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the jar file to the container
COPY target/spring-petclinic-2.3.0.BUILD-SNAPSHOT.jar /app/spring-petclinic.jar

# Expose the port that the app runs on
EXPOSE 8081

# Run the jar file
ENTRYPOINT ["java", "-jar", "/app/spring-petclinic.jar"]
