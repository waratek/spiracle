# =============================================================================
# Parameterised multi-version build for Spiracle (Java 6 .. 25).
#
# A SINGLE Dockerfile builds and runs the app on any Java version by varying
# these build args. Defaults reproduce the historical Java 8 / Tomcat 9 image.
#
#   BUILD_JDK       JDK image used to COMPILE the WAR and assemble Tomcat
#                   (8|11|17|21|25). No single JDK can target every source
#                   level, so it is picked per band.
#   VERSION_JDK     -Dversion.jdk source/target level (1.6|1.7|1.8|9..25).
#   VERSION_WEBXML  Servlet descriptor (25|30).
#   MAVEN_OPTS      Extra JVM flags for Maven (the matrix sets --add-opens for
#                   build JDK >= 16, which the legacy plugins need).
#   TOMCAT_MAJOR    Tomcat major line (9 for Java 8+; 7/8 for the Java 6/7 tail).
#   TOMCAT_VERSION  Apache Tomcat patch release (from the dist archive).
#   RUNTIME_BASE    JRE image the agent actually instruments (e.g.
#                   eclipse-temurin:17-jre). This is the "run on Java N" knob.
#
# All network/extraction work happens in the BUILD stage (modern image, working
# apt/curl/jar). The runtime stage only COPYs a self-contained Tomcat, so it
# needs nothing but a JRE + shell — it works on minimal or legacy (Java 6/7)
# bases whose package repos are dead. See docs/multi-version-testing.md.
# =============================================================================

# ARGs consumed by a FROM must be declared in the global scope (before the
# first FROM). BUILD_JDK selects the build image; RUNTIME_BASE the runtime image.
ARG BUILD_JDK=8
ARG RUNTIME_BASE=eclipse-temurin:8-jre

# ---------------------------------------------------------------------------
# Stage 1: build the WAR and assemble a self-contained Tomcat with the WAR
# exploded and the JDBC drivers in place. BUILD_JDK must support the requested
# VERSION_JDK source level (JDK 8 -> 1.6/1.7/1.8; JDK 25 -> 8..25).
# ---------------------------------------------------------------------------
FROM maven:3.9-eclipse-temurin-${BUILD_JDK} AS build

ARG VERSION_JDK=1.8
ARG VERSION_WEBXML=30
# The pinned legacy Maven plugins (war-plugin 2.4 …) do deep reflection that
# JDK 16+ blocks by default; the matrix sets MAVEN_OPTS to the needed
# --add-opens for build JDK >= 16 (empty on JDK 8/11).
ARG MAVEN_OPTS=""
ENV MAVEN_OPTS=${MAVEN_OPTS}
ARG TOMCAT_MAJOR=9
ARG TOMCAT_VERSION=9.0.118

WORKDIR /build
COPY pom.xml .
COPY src ./src

RUN mvn install -Dversion.jdk=${VERSION_JDK} -Dversion.webxml=${VERSION_WEBXML} -DskipTests -q

# Assemble Tomcat under /opt/tomcat: download (archive.apache.org keeps every
# patch; dlcdn only the latest), drop default webapps, explode the WAR with
# `jar`, and fetch the JDBC drivers into lib/. NOTE: ojdbc8 / mssql-jdbc.jre8
# need Java 8+ and won't load on the Java 6/7 tail (logged, non-fatal); MySQL
# Connector/J 5.1.49 works on every level.
RUN set -eux; \
    curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -o /tmp/tomcat.tgz; \
    mkdir -p /opt/tomcat; \
    tar xzf /tmp/tomcat.tgz -C /opt/tomcat --strip-components=1; \
    rm /tmp/tomcat.tgz; \
    rm -rf /opt/tomcat/webapps/*; \
    mkdir -p /opt/tomcat/webapps/spiracle; \
    (cd /opt/tomcat/webapps/spiracle && jar xf /build/target/spiracle.war); \
    curl -fsSL "https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar" \
         -o /opt/tomcat/lib/mysql-connector-java-5.1.49.jar; \
    curl -fsSL "https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/12.4.2.jre8/mssql-jdbc-12.4.2.jre8.jar" \
         -o /opt/tomcat/lib/mssql-jdbc-12.4.2.jre8.jar; \
    curl -fsSL "https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/21.13.0.0/ojdbc8-21.13.0.0.jar" \
         -o /opt/tomcat/lib/ojdbc8-21.13.0.0.jar

# ---------------------------------------------------------------------------
# Stage 2: runtime. Just a JRE + the assembled Tomcat — no package installs,
# so any JRE base works (Temurin 8..25, or a legacy Azul Zulu 6/7 for the tail).
# ---------------------------------------------------------------------------
FROM ${RUNTIME_BASE} AS runtime

ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH="${CATALINA_HOME}/bin:${PATH}"

COPY --from=build /opt/tomcat ${CATALINA_HOME}
COPY --chmod=0755 docker/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
