# Use an official Maven image to build the WAR
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom and source
COPY pom.xml .
COPY src ./src

# Build the WAR file
RUN mvn clean package -DskipTests

# Use Tomcat for runtime
FROM tomcat:10.1-jdk17
# Remove default webapps (optional, keeps image cleaner)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR built by Maven into Tomcat
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port Tomcat listens on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

