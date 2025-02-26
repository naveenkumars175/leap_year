# Use Tomcat base image
FROM tomcat:9.0

# Copy WAR file into Tomcat webapps directory
COPY build/leap-year.war /usr/local/tomcat/webapps/

# Expose port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
