# Use a base image with JDK installed
FROM openjdk:17-jdk

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file generated by Maven/Gradle
COPY target/*.jar /app

# Expose the port your application will run on
EXPOSE 8082

# Command to run the application
CMD ["java", "-jar", "/app/your-app.jar", "--server.port=8082"]
