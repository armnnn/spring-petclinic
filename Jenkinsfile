pipeline {
    agent none
    
    environment {
        ARTIFCATORY_SERVER_ID = 'ArminDemo'
        ARTIFACROTY_URL = 'armindemo.jfrog.io'
        IMAGE_NAME = 'armindemo.jfrog.io/docker/spring-clinic:latest'
        GIT_REPO = 'https://github.com/armnnn/spring-petclinic.git'
    }

    stages {
        stage ('Artifactory configuration') {
            agent any
            steps {
                rtServer (
                    id: ARTIFCATORY_SERVER_ID,
                    url: ARTIFACROTY_URL,
                    credentialsId: "artifactory-username-pw"
                )
            }
        }
        
        stage ('Checkout') {
            agent any
            steps {
                git branch: 'main', url: GIT_REPO
            }
        }

        stage('Compile') {
            agent { docker { image 'maven:3.8.6-openjdk-18' } }
            steps {
                sh 'mvn clean compile -Dcheckstyle.skip'
            }
        }

        stage('Test') {
            agent { docker { image 'maven:3.8.6-openjdk-18' } }
            steps {
                sh 'mvn clean test -Dcheckstyle.skip'
            }
        }

        stage('Package') {
            agent { docker { image 'maven:3.8.6-openjdk-18' } }
            steps {
                sh 'mvn clean package -Dmaven.test.skip -Dcheckstyle.skip'
            }
        }

        stage ('Build docker image') {
            agent any
            steps {
                script {
                    docker.build(IMAGE_NAME, '.')
                }
            }
        }

        stage ('Push image to Artifactory') {
            agent any
            steps {
                rtDockerPush(
                    serverId: ARTIFCATORY_SERVER_ID,
                    image: IMAGE_NAME,
                    targetRepo: 'docker-local',
                    // Attach custom properties to the published artifacts:
                    properties: 'project-name=spring-petclinic;status=stable'
                )
            }
        }
    }
}
