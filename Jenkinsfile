pipeline {
    agent { label 'dev' }

    parameters {
        string(name: 'CONTAINER_NAME', defaultValue: 'cont-1', description: 'Name for the new container')
        string(name: 'HOST_PORT', defaultValue: '3333', description: 'Host port to expose the app on')
    }

    stages {
        stage("Code Checkout") {
            steps {
                git branch: 'master', url: 'https://github.com/sumanthtony/Java_maven_one_repo.git'
            }
        }
        stage("Docker build") {
            steps {
                sh 'docker build -t demo-image .'
            }
        }
        stage("Deploy the Java app using docker container") {
            steps {
                sh """
                # 1. Remove ALL old containers (running or stopped) created from demo-image
                docker ps -aq --filter "ancestor=demo-image" | xargs -r docker rm -f

                # 2. Remove any container holding the chosen name or chosen host port
                docker rm -f ${params.CONTAINER_NAME} || true
                docker ps -aq --filter "publish=${params.HOST_PORT}" | xargs -r docker rm -f

                # 3. Run the new container with your chosen name and port
                docker run -d --name ${params.CONTAINER_NAME} -p ${params.HOST_PORT}:8080 demo-image
                """
            }
        }
    }
}
