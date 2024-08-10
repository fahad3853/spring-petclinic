pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Replace with your DockerHub credentials ID
        NEXUS_CREDENTIALS = credentials('nexus-credentials') // Replace with your Nexus credentials ID
        DOCKERHUB_REPO = 'fahadkhan3853/spring-petclinic' // Replace with your DockerHub repository
        NEXUS_REPO_URL = 'http://your-nexus-repo-url/repository/maven-releases/' // Replace with your Nexus repository URL
    }
    
    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/fahad3853/spring-petclinic.git' // Replace with your GitHub repository URL
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests' // Builds the project and creates the JAR file
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t ${DOCKERHUB_REPO}:latest .'
                }
            }
        }
        
        stage('Run and Test Docker Container') {
            steps {
                script {
                    // Generate a unique container name
                    def containerName = "spring-petclinic-test-${env.BUILD_ID}"
                    
                    // Run Docker container on port 8082
                    sh "docker run -d --name ${containerName} -p 8082:8080 ${DOCKERHUB_REPO}:latest"
                    
                    // Wait for the application to start
                    sleep(time: 30, unit: 'SECONDS')
                    
                    // Test the application
                    def statusCode = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8082/actuator/health', returnStdout: true).trim()
                    if (statusCode != '200') {
                        error "Application is not running. Status code: ${statusCode}"
                    }
                    
                    // Print a message indicating the container is running and accessible
                    echo "Container is running and accessible at http://localhost:8082"
                }
            }
        }
    }
}
