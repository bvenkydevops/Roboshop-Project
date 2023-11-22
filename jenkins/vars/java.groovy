def call(Map params = [:]) {
  // Start Default Arguments
  def args = [
      COMPONENT                  : '',
      LABEL                      : 'master'
  ]
  args << params

  pipeline {
    agent {
      label params.LABEL
    }

    environment {
      NEXUS = credentials("NEXUS")
    }

    stages {

      stage('Labeling Build') {
        steps {
          script {
            str = GIT_BRANCH.split('/').last()
            //addShortText background: 'yellow', color: 'black', borderColor: 'yellow', text: "COMPONENT = ${params.COMPONENT}"
            addShortText background: 'yellow', color: 'black', borderColor: 'yellow', text: "BRANCH = ${str}"
//            addShortText background: 'orange', color: 'black', borderColor: 'yellow', text: "${ENV}"
          }
        }
      }

      stage('Maven Package') {
        steps {
          sh """
            mvn package
          """
        }
      }

      stage('Submit Code Quality') {
        steps {
          sh """
            #sonar-scanner -Dsonar.projectKey=${params.COMPONENT} -Dsonar.sources=. -Dsonar.java.binaries=target/. -Dsonar.host.url=http://172.31.28.20:9000 -Dsonar.login=b1edb395b6a67961b8716cf4ac49cddb8e39f6d5
            echo OK
          """
        }
      }

      stage('Check Code Quality Gate') {
        steps {
          sh """
            #sonar-quality-gate.sh admin admin123 172.31.28.20 ${params.COMPONENT}
            echo OK 
          """
        }
      }


      stage('Test Cases') {
        steps {
          sh 'echo Test Cases'
        }
      }

      stage('Upload Artifacts') {
        when {
          expression { sh([returnStdout: true, script: 'echo ${GIT_BRANCH} | grep tags || true' ]) }
        }
        steps {
          sh """
          GIT_TAG=`echo ${GIT_BRANCH} | awk -F / '{print \$NF}'`
          echo \${GIT_TAG} >version
          cp target/${params.COMPONENT}-1.0.jar ${params.COMPONENT}.jar
          zip -r ${params.COMPONENT}-\${GIT_TAG}.zip ${params.COMPONENT}.jar version
          curl -f -v -u ${NEXUS} --upload-file ${params.COMPONENT}-\${GIT_TAG}.zip http://172.31.7.184:8081/repository/${params.COMPONENT}/${params.COMPONENT}-\${GIT_TAG}.zip
          """
        }
      }

    }

    post {
      always {
        cleanWs()
      }
    }

  }

}
