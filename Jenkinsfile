pipeline {
    agent any
        environment {
        nodeVersion = '12.13.0' // Specify the desired Node.js version
        }

        stages {
        stage('Git checkout') {
            steps{
                // Get source code from a GitHub repository
                git branch:'grace', credentialsId:'SSH-key', url:'git@github.com:Grace-Si/GoExpertsFrontend.git'
            }
        }
        stage('Setup node version') {
            steps {
                script {
                    // Download and set up Node.js in the pipeline workspace
                    tool name: 'node', type: 'hudson.plugins.nodejs.tools.NodeJSInstallation', installable: 'NodeJS_' + env.nodeVersion

                    // Use the downloaded Node.js in the pipeline
                    def nodeHome = tool name: 'node', type: 'hudson.plugins.nodejs.tools.NodeJSInstallation'
                    env.PATH = "${nodeHome}/bin:${env.PATH}"
                    sh 'node --version' // Verify Node.js version
                }
            }
        }
        stage('Install') {
            steps{
                dir("./") {
                    sh 'npm install'
                }
            }
        }

        stage('Test') {
            steps{
                dir("./") {
                    sh 'echo "test"'
                }
            }
        }

        stage('Build') {
            steps{
                dir("./") {
                    sh 'npm run build'
                }
            }
        }
      
        stage('Upload') {
            steps {
                dir("./") {
                    withAWS (region:"ap-southeast-2", credentials:"AWS-Credential") {
                    s3Delete(bucket: 'goexpertsfe', path:'**/*')
                    s3Upload(bucket: 'goexpertsfe', workingDir:'build', includePathPattern:'**/*');
                    }
                }
            }
        }

    }
}