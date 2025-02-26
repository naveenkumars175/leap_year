pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/naveenkumars175/leap_year.git'
            }
        }

        stage('Prepare WAR File') {
            steps {
                sh 'mkdir -p build'
                sh 'sudo cp build/leap-year.war $WORKSPACE/'  
                sh 'sudo cp build/leap-year.war /home/naveenkumar/tomcat9/webapps/'  // Copy instead of move
                sh 'ls -l $WORKSPACE/'  // Debugging
            }
        }

        stage('Restart Tomcat') {
            steps {
                sh 'sudo /home/naveenkumar/tomcat9/bin/shutdown.sh || echo "Tomcat not running, skipping shutdown"'
                sleep 5  // Allow time for shutdown
                sh 'sudo /home/naveenkumar/tomcat9/bin/startup.sh'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'cp $WORKSPACE/leap-year.war .'
                sh 'docker build -t leap-year-app .'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker run -d -p 8080:8080 --name leap-year-container leap-year-app'
            }
        }
    }
}

