# Stage 1: build the WAR using Java 8 + Maven
FROM maven:3.9-eclipse-temurin-8 AS build

WORKDIR /build
COPY pom.xml .
COPY src ./src

RUN mvn install -Dversion.webxml=30 -DskipTests -q

# ---------------------------------------------------------------------------
# Stage 2: runtime — Tomcat 9 + JRE 8
# ---------------------------------------------------------------------------
FROM tomcat:9-jre8-temurin AS runtime

# Remove default webapps
RUN rm -rf "$CATALINA_HOME/webapps/ROOT" \
           "$CATALINA_HOME/webapps/docs" \
           "$CATALINA_HOME/webapps/examples" \
           "$CATALINA_HOME/webapps/host-manager" \
           "$CATALINA_HOME/webapps/manager"

# Copy and pre-explode the WAR so the entrypoint can edit conf/ on disk
COPY --from=build /build/target/spiracle.war /tmp/spiracle.war
RUN apt-get update -qq && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/* \
 && mkdir -p "$CATALINA_HOME/webapps/spiracle" \
 && unzip -q /tmp/spiracle.war -d "$CATALINA_HOME/webapps/spiracle" \
 && rm /tmp/spiracle.war

# ---- JDBC drivers (downloaded at image build time from Maven Central) ----

# MySQL Connector/J 5.1.49 — has com.mysql.jdbc.Driver (legacy classname)
RUN curl -fsSL \
    "https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar" \
    -o "$CATALINA_HOME/lib/mysql-connector-java-5.1.49.jar"

# MSSQL JDBC — jre8 classifier
RUN curl -fsSL \
    "https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/12.4.2.jre8/mssql-jdbc-12.4.2.jre8.jar" \
    -o "$CATALINA_HOME/lib/mssql-jdbc-12.4.2.jre8.jar"

# Oracle ojdbc8 — Java 8 compatible
RUN curl -fsSL \
    "https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/21.13.0.0/ojdbc8-21.13.0.0.jar" \
    -o "$CATALINA_HOME/lib/ojdbc8-21.13.0.0.jar"

# ---- entrypoint ----
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
