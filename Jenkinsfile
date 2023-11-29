pipeline {
    agent any
        
        stages {
        stage('Git checkout') {
            steps{
                // Get source code from a GitHub repository
                git branch:'grace', credentialsId:'SSH-key', url:'git@github.com:Grace-Si/GoExpertsFrontend.git'
            }
        }
        stage('Setup') {
            environment {
                nodeVersion = '12.18.4' // Specify the desired Node.js version
            }
            steps {
                script {
                    // Download and set up Node.js in the pipeline workspace
                    tool name: 'node', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation', 
                         label: '', // If applicable, specify a label where NodeJS tool is configured
                         command: "install ${env.nodeVersion}"

                    // Use the downloaded Node.js in the pipeline
                    def nodeHome = tool name: 'node', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation'
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