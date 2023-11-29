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
                        // Install Node.js using NVM
                        sh 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash' // Install NVM
                        sh "export NVM_DIR=\"\$HOME/.nvm\"" // Set NVM directory
                        sh "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"" // Load NVM script
                        sh "nvm install ${env.nodeVersion}" // Install specific Node.js version
                        sh "nvm use ${env.nodeVersion}" // Use the installed Node.js version
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