pipeline {
  agent {
    label 'agent'
  }
  triggers {
    cron('0 11 * * *')
  }
  stages {
    stage('eu-west-1') {
      agent {
        dockerfile {
          reuseNode true
          filename 'Dockerfile'
        }
      }
      environment { 
        AWS_DEFAULT_REGION = 'eu-west-1'
      }
      steps {
        echo 'Starting EC2 Network Benchmark'
        sh 'AWS_DEFAULT_REGION=eu-west-1 ./benchmark.sh'
        echo 'Finished EC2 Network Benchmark'
      }
    }
  }
  post {
    failure {
      mail to: 'andreas@widdix.de', subject: "FAILURE: ${currentBuild.fullDisplayName}", body: "EC2 Networking Benchmark failed: ${currentBuild.fullDisplayName}."
    }
  }
}
