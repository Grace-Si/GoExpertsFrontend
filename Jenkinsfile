pipeline {
    agent any
        
        tools {
            nodejs 'NodeJS-12' // Referring to the configured Node.js installation name
        }

        stages {
            stage('Git checkout') {
                steps{
                    // Get source code from a GitHub repository
                    git branch:'grace', credentialsId:'SSH-key', url:'git@github.com:Grace-Si/GoExpertsFrontend.git'
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