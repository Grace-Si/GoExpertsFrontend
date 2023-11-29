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
                        echo "test"
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
                    script {
                        withAWS(region: 'ap-southeast-2', credentials: 'AWS-Credential') {
                            def s3UploadParams = [
                                bucket: 'goexpertsfe',
                                workingDir: 'build',
                                includePathPattern: '**/*'
                            ]
                            s3Upload s3UploadParams
            }
        }
    }
}

        }
}