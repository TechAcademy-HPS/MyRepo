def buildno = BUILD_NUMBER
pipeline {
    agent any
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven3.6.3"
    }
    
	
	environment {
        registry = "332303016470.dkr.ecr.ap-south-1.amazonaws.com/mydockerrepo"
    }
	
    stages {
        stage('checkout') {
            steps {
                git credentialsId: 'githubcredentials', url: 'https://github.com/TechAcademy-HPS/maven-web-application-1.git'
            }
        }
		
         stage('Build'){
             steps{
	            sh "mvn clean package"
	              }
        }  
		
        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build registry 
                }
            }
        }
		     
        stage('Pushing to ECR') {
             steps{  
                 script {
                sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 332303016470.dkr.ecr.ap-south-1.amazonaws.com'
                sh 'docker push 332303016470.dkr.ecr.ap-south-1.amazonaws.com/mydockerrepo:latest'
                }
            }
         }			 
  
         stage('K8S Deploy') {
             steps{   
              script {
                  withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', serverUrl: '') {
                    sh ('kubectl apply -f  eks-deploy-k8s.yaml')
                 }
             }
            }
        }
			
        }
}
