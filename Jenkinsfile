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
                sh 'cp build/leap-year.war $WORKSPACE/'  // Ensure the WAR file is available
                sh 'ls -l $WORKSPACE/'  // Debugging: List files to verify WAR is present
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh 'sudo mv $WORKSPACE/leap-year.war /home/naveenkumar/tomcat9/webapps/'
            }
        }

        stage('Restart Tomcat') {
            steps {
                sh 'sudo /home/naveenkumar/tomcat9/bin/shutdown.sh || echo "Tomcat not running, skipping shutdown"'
                sh 'sudo /home/naveenkumar/tomcat9/bin/startup.sh'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'cp $WORKSPACE/leap-year.war .'  // Copy WAR to Docker build context
                sh 'docker build -t leap-year-app .'  // Build Docker image
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker stop leap-year-container || true'  // Stop existing container if running
                sh 'docker rm leap-year-container || true'  // Remove old container
                sh 'docker run -d -p 8080:8080 --name leap-year-container leap-year-app'
            }
        }
    }
}

