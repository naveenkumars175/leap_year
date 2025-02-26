pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/naveenkumars175/leap_year.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mkdir -p build'
                sh 'jar -cvf build/leap-year.war -C src/main/webapp .'
		sh 'ls -l build/'
		sh 'cp /home/naveenkumar/tomcat9/webapps/leap-year.war build/leap-year.war'
        sh 'cp build/leap-year.war $WORKSPACE/'
	        sh 'ls -l $WORKSPACE/'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh 'sudo mv build/leap-year.war /home/naveenkumar/tomcat9/webapps/'
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

