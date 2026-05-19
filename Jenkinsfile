pipeline {
      agent any

      triggers {
          cron('H/5 * * * *')
      }

      parameters {
          choice(name: 'DEPLOY_ENV', choices: ['dev', 'staging', 'prod'], description: 'Target deployment environment')
          booleanParam(name: 'SKIP_PUSH', defaultValue: false, description: 'Skip pushing image to Docker Hub')
          string(name: 'CUSTOM_TAG', defaultValue: '', description: 'Custom image tag')
      }

      environment {
          DOCKERHUB_USER = 'orest1234'
          IMAGE_NAME     = 'prkim'
          REGISTRY_IMAGE = "${DOCKERHUB_USER}/${IMAGE_NAME}"
          IMAGE_TAG      = "${params.CUSTOM_TAG ?: env.BUILD_NUMBER}"
      }

      stages {
          stage('Start') {
              steps {
                  echo "Pipeline #${BUILD_NUMBER} [${params.DEPLOY_ENV}]"
                  script {
                      currentBuild.displayName = "#${BUILD_NUMBER} [${params.DEPLOY_ENV}] ${IMAGE_TAG}"
                  }
              }
          }
          stage('Build') {
              steps {
                  sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                  sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_IMAGE}:${IMAGE_TAG}"
                  sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_IMAGE}:latest"
              }
          }
          stage('Test') {
              steps {
                  sh "docker run --rm -d --name test-${BUILD_NUMBER} -p 8888:80 ${IMAGE_NAME}:${IMAGE_TAG}"
                  sh "sleep 3 && curl -f http://localhost:8888"
                  sh "docker stop test-${BUILD_NUMBER}"
                  echo 'Test passed'
              }
          }
          stage('Push') {
              when { expression { return !params.SKIP_PUSH } }
              steps {
                  withDockerRegistry([credentialsId: "dockerhub_token", url: ""]) {
                      sh "docker push ${REGISTRY_IMAGE}:${IMAGE_TAG}"
                      sh "docker push ${REGISTRY_IMAGE}:latest"
                  }
              }
          }
          stage('Deploy') {
              steps {
                  sh "docker rm -f lab1-nginx || true"
                  sh "docker run -d --name lab1-nginx -p 80:80 ${REGISTRY_IMAGE}:latest"
              }
          }
          stage('Report') {
              steps {
                  script {
                      def reportDir = 'build-report'
                      sh "mkdir -p ${reportDir}"
                      writeFile file: "${reportDir}/index.html", text: """
                          <html><body>
                          <h2>Build Report #${BUILD_NUMBER}</h2>
                          <table border='1'>
                              <tr><td>Image</td><td>${REGISTRY_IMAGE}:${IMAGE_TAG}</td></tr>
                              <tr><td>Environment</td><td>${params.DEPLOY_ENV}</td></tr>
                              <tr><td>Status</td><td>SUCCESS</td></tr>
                          </table>
                          </body></html>
                      """
                      publishHTML(target: [reportName: 'Build Report', reportDir: reportDir, reportFiles: 'index.html', keepAll: true, alwaysLinkToLastBuild: true])
                  }
              }
          }
      }

      post {
          success { echo "SUCCESS - deployed to ${params.DEPLOY_ENV}" }
          failure { echo 'FAILED - check logs' }
      }
  }
