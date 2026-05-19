pipeline {
      agent any
      stages {
          stage('Start') {
              steps {
                  echo 'Lab_2: started by GitHub'
              }
          }
          stage('Image build') {
              steps {
                  sh "docker build -t prkim:latest ."
                  sh "docker tag prkim orest1234/prkim:latest"
                  sh "docker tag prkim orest1234/prkim:$BUILD_NUMBER"
              }
          }
          stage('Push to registry') {
              steps {
                  withDockerRegistry([ credentialsId: "dockerhub_token", url: "" ]) {
                      sh "docker push orest1234/prkim:latest"
                      sh "docker push orest1234/prkim:$BUILD_NUMBER"
                  }
              }
          }
          stage('Deploy image') {
              steps {
                  sh "docker rm -f lab1-nginx || true"
                  sh "docker run -d --name lab1-nginx -p 80:80 orest1234/prkim"
              }
          }
      }
  }
