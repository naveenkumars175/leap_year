# Use Tomcat base image
FROM tomcat:9.0

# Copy WAR file into Tomcat webapps directory
COPY build/leap-year.war /usr/local/tomcat/webapps/

# Expose port
EXPOSE 9091

# Enable BuildKit for better performance
ENV DOCKER_BUILDKIT=1

# Start Tomcat server
CMD ["catalina.sh", "run"]

