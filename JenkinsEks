def buildno = BUILD_NUMBER
pipeline {
    agent any
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven3.6.3"
    }
    
	
	environment {
        registry = "332303016470.dkr.ecr.ap-south-1.amazonaws.com/mydockerrepo:${buildno}"
    }
	
    stages {
      	
         stage('Build'){
             steps{
	            sh "cd mavenapp"
		    sh "mvn clean package"
	              }
        }  
	
	stage('Building image') {
            steps{
                script {
			  sh "docker build -t yoshithadocker/mydockerrepo:${buildno} ." 
                     }
                  }
              }
	      
	stage('push to repo') {
            steps{
                script {
			  withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerpassword', usernameVariable: 'dockeruser')]) {
                                        
					sh 'docker login -u yoshithadocker -p ${dockerpassword}'
			                sh "docker push yoshithadocker/mydockerrepo:latest"
                     }
                  }
              }
          }
	 
         stage('K8S Deploy') {
             steps{   
              script {
                 
		      kubeconfig(credentialsId: 'kubeconfig', serverUrl: 'https://394B0D2B64F459D83B8A7C980116DC28.gr7.us-east-2.eks.amazonaws.com') {
                                 sh ('kubectl apply -f  eks-deploy-k8s.yaml')
                             }
             }
            }
        }

     }

}
