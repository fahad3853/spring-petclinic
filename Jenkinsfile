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
                sh './mvn clean package' // Builds the project and creates the JAR file
            }
        }
        
        stage('Test') {
            steps {
                sh 'docker-compose up -d' // Run the application in a Docker container
                script {
                    def appRunning = sh(script: "curl -s http://localhost:8080/actuator/health | grep 'UP'", returnStatus: true)
                    if (appRunning != 0) {
                        error("Application failed to start.")
                    }
                }
            }
        }
        
        stage('Create Docker Image') {
            when {
                expression { sh(script: "curl -s http://localhost:8080/actuator/health | grep 'UP'", returnStatus: true) == 0 }
            }
            steps {
                sh "docker build -t ${DOCKERHUB_REPO}:latest ."
            }
        }
        
        stage('Push Docker Image') {
            when {
                expression { sh(script: "curl -s http://localhost:8080/actuator/health | grep 'UP'", returnStatus: true) == 0 }
            }
            steps {
                script {
                    docker.withRegistry('', 'DOCKERHUB_CREDENTIALS') {
                        sh "docker push ${DOCKERHUB_REPO}:latest"
                    }
                }
            }
        }
        
        stage('Push JAR to Nexus') {
            steps {
                script {
                    def jarFile = findFiles(glob: '**/target/*.jar')[0]
                    sh """
                        curl -v -u ${NEXUS_CREDENTIALS_USR}:${NEXUS_CREDENTIALS_PSW} \
                        --upload-file ${jarFile.path} \
                        ${NEXUS_REPO_URL}${jarFile.name}
                    """
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml' // Assumes you have a Kubernetes deployment YAML file ready
                sh 'kubectl apply -f k8s/service.yaml' // Assumes you have a Kubernetes service YAML file ready
            }
        }
    }
    
    post {
        always {
            sh 'docker-compose down' // Stop the Docker container
        }
    }
}
