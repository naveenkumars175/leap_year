pipeline {
    agent any

    environment {
        TOMCAT_HOME = "/home/naveenkumar/tomcat9"
        WORKSPACE_DIR = "/var/lib/jenkins/workspace/Leap-year"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/naveenkumars175/leap_year.git'
            }
        }

        stage('Prepare WAR File') {
            steps {
                sh 'mkdir -p build'
                sh 'sudo cp build/leap-year.war ${WORKSPACE_DIR}/'
                sh 'sudo cp build/leap-year.war ${TOMCAT_HOME}/webapps/'
            }
        }

        stage('Restart Tomcat') {
            steps {
                script {
                    def tomcatPID = sh(script: "ps -ef | grep tomcat | grep -v grep | awk '{print \$2}'", returnStdout: true).trim()
                    if (tomcatPID) {
                        sh "sudo ${TOMCAT_HOME}/bin/shutdown.sh"
                        sleep 5
                    } else {
                        echo "Tomcat is not running, skipping shutdown."
                    }
                }
                sh "sudo ${TOMCAT_HOME}/bin/startup.sh"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                if [ ! -f leap-year.war ]; then
                    cp -f ${WORKSPACE_DIR}/leap-year.war .
                fi
                docker build -t leap-year-app .
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    def containerExists = sh(script: "docker ps -aqf 'name=leap-year-container'", returnStdout: true).trim()
                    if (containerExists) {
                        sh "docker stop leap-year-container && docker rm leap-year-container"
                    }
                }
                sh "docker run -d --name leap-year-container -p 8080:8080 leap-year-app"
            }
        }
    }

    post {
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed. Check logs for errors."
        }
    }
}

