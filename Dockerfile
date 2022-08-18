FROM tomcat:8.0.52
COPY mavenapp/target/*.war /usr/local/tomcat/webapps/mavenapp.war

