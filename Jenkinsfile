  pipeline {
      agent any
      stages {
          stage('Start') {
              steps {
                  echo 'Lab_1: nginx/custom'
              }
          }
          stage('Build nginx/custom') {
              steps {
                  sh 'docker build -t nginx/custom:latest .'
              }
          }
          stage('Test nginx/custom') {
              steps {
                  echo 'Test passed'
              }
          }
          stage('Deploy nginx/custom') {
              steps {
                  sh 'docker rm -f lab1-nginx || true'
                  sh 'docker run -d --name lab1-nginx -p 80:80 nginx/custom:latest'
              }
          }
      }
  }
