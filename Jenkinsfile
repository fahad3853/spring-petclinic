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
                    // Run Docker container on port 8082
                    sh 'docker run -d --name spring-petclinic-test -p 8082:8080 ${DOCKERHUB_REPO}:latest'
                    
                    // Wait for the application to start
                    sleep(time: 30, unit: 'SECONDS')
                    
                    // Test the application
                    def statusCode = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8082/actuator/health', returnStdout: true).trim()
                    if (statusCode != '200') {
                        error "Application is not running. Status code: ${statusCode}"
                    }
                    
                    // Stop and remove the container
                    sh 'docker stop spring-petclinic-test'
                    sh 'docker rm spring-petclinic-test'
                }
            }
        }
        
       // stage('Push Docker Image') {
         //   steps {
           //     script {
                    // Login to DockerHub
             //       sh 'echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin'
                    
                    // Push Docker image to DockerHub
               //     sh 'docker push ${DOCKERHUB_REPO}:latest'
//                }
  //          }
    //    }
    }
}
