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
        /*stage('checkout') {
            steps {
                git credentialsId: 'githubcredentials', url: 'https://github.com/TechAcademy-HPS/MyRepo.git'
            }
        }*/
		
         stage('Build'){
             steps{
	            sh "cd mavenapp;mvn clean package"
	              }
        }  
	stage('sonar') {
            steps {
		    script {
                withSonarQubeEnv('SonarQube') {
                sh "cd mavenapp;mvn sonar:sonar"
                }
               timeout(time: 20, unit: 'SECONDS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    }
                 }
	      }
           }
	stage('upload to nexus') {
            steps {
                nexusArtifactUploader artifacts: [
				[
				artifactId: 'maven-web-application',
				classifier: '',
				file: 'target/maven-web-application.war',
				type: 'war'
				]
				],
				credentialsId: 'nexuscredentials',
				groupId: 'com.mt',
				nexusUrl: '43.205.194.100:8081',
				nexusVersion: 'nexus3',
				protocol: 'http',
				repository: 'mavenapp',
				version: '0.0.1'
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
