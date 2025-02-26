pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/naveenkumars175/leap_year.git'
            }
        }

        stage('Compile and Package') {
            steps {
                sh 'javac -d build $(find src -name "*.java")'
                sh 'mkdir -p build/WEB-INF/classes'
                sh 'cp -r build/* build/WEB-INF/classes/'
                sh 'mkdir -p build/WEB-INF'
                sh 'cp -r web/WEB-INF/* build/WEB-INF/'
                sh 'jar cvf build/leap_year.war -C build .'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh 'cp build/leap_year.war /home/naveenkumar/tomcat9/webapps/'

                script {
                    sh '''
                    if pgrep -f "org.apache.catalina.startup.Bootstrap" > /dev/null
                    then
                        echo "Stopping Tomcat..."
                        sudo /home/naveenkumar/tomcat9/bin/shutdown.sh
                        sleep 5
                    else
                        echo "Tomcat is not running. Skipping shutdown."
                    fi
                    '''
                    sh 'sudo /home/naveenkumar/tomcat9/bin/startup.sh'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t leap-year-app .'
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh '''
                    if docker ps -a --format '{{.Names}}' | grep -q leap-year-container; then
                        echo "Removing existing container..."
                        docker stop leap-year-container
                        docker rm leap-year-container
                    fi

                    docker run -d --name leap-year-container -p 9091:8080 leap-year-app
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "Deployment failed. Check logs for errors."
        }
    }
}

