# Spiracle

Spiracle is an insecure web application used to test system security controls.

It can be used to read/write arbitrary files and open network connections.
The application is also vulnerable to numerous other vulnerabilities such as:

- SQL Injection (CWE-89)
- XSS (CWE-79)
- CSRF (CWE-352)
- Path Traversal (CWE-22)
- Deserialization (CWE-502)
- and many more...

> **⚠️ Caution:** Due to its insecure design, this application should NOT be deployed on an unsecured network or system. Run on localhost or throwaway networks only.

This application has been tested on the following application servers:

- Apache Tomcat 7.x
- IBM WebSphere Liberty Core 8.5.5.3

Your mileage may vary with other application servers.

## Docker (quickstart)

The fastest way to run Spiracle. No local Tomcat or database install needed.

Pick a database and run its compose file from the repo root:

```sh
# MySQL (smallest image — recommended for first run)
$ docker compose -f docker-compose.mysql.yml up --build

# Microsoft SQL Server (~1.5 GB image)
$ docker compose -f docker-compose.mssql.yml up --build

# Oracle XE (~2–4 GB image; first pull takes several minutes)
$ docker compose -f docker-compose.oracle.yml up --build
```

Once healthy, browse to: http://localhost:8080/spiracle/

Tear down (removes volumes):

```sh
$ docker compose -f docker-compose.mysql.yml down -v
```

The multi-stage `Dockerfile` builds the WAR with JDK 8 / Maven (using `-Dversion.jdk=1.4 -Dversion.webxml=25`) and deploys it on Tomcat 9. `docker/entrypoint.sh` rewrites `conf/Spiracle.properties` from environment variables at startup.

> **Note — JDBC drivers on `java4`:** The Docker image places modern drivers in Tomcat's `lib/` — MySQL Connector/J 5.1.49, MSSQL `mssql-jdbc` 12.4.2.jre8, and Oracle `ojdbc8` 21.13. The `java4` WAR *also* bundles the legacy `mysql-connector 3.1.14` and `jTDS 1.2` in `WEB-INF/lib`. For MySQL the webapp classloader prefers the WAR's `3.1.14` over the Tomcat-lib `5.1.49` (this is why the MySQL stack must pin `mysql:5.7`). For MSSQL and Oracle the application targets the Tomcat-lib drivers — `Spiracle.properties` configures `com.microsoft.sqlserver.jdbc.SQLServerDriver` (`jdbc:sqlserver://`) and `oracle.jdbc.driver.OracleDriver`, so the WAR's `jTDS` jar is retained for legacy parity but is not the active MSSQL driver.

> **Note:** The MySQL compose file pins `mysql:5.7`. The `java4` WAR bundles the legacy `mysql-connector 3.1.14`, which cannot negotiate MySQL 8's `utf8mb4` charset (index 255); MySQL 5.7 is required for the old connector to connect.

Full Docker reference: [docker/README.md](docker/README.md)

## Installation

- Download pre-built `spiracle.war` file from the releases page: https://github.com/waratek/spiracle/releases

### Tomcat

- Copy the war file to the `$CATALINA_HOME/webapps/` directory.

### Liberty Core

- Ensure that the application war file is extracted to your server's apps directory:

  ```sh
  $ mkdir ./wlp/usr/servers/defaultServer/apps/spiracle
  $ cd ./wlp/usr/servers/defaultServer/apps/spiracle
  $ jar xvf /path/to/downloaded/spiracle.war
  ```

- Modify `server.xml` as follows:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <server description="new server">
    <!-- Enable features -->
    <featureManager>
      <feature>jsp-2.2</feature>
      <feature>Servlet-3.0</feature>          <!-- (1) Enable Servlet-3.0 as a feature -->
    </featureManager>

    <webApplication contextRoot="spiracle" location="spiracle"/>  <!-- (2) webApplication tag referencing Spiracle -->
    <httpSession idLength="28" />             <!-- (3) Change httpSession parameter length -->

    <httpEndpoint id="defaultHttpEndpoint"
                  host="*"                    <!-- (4) Add a host attribute -->
                  httpPort="9080"
                  httpsPort="9443"/>
  </server>
  ```

> **Note:** WebSphere Liberty has no Servlet 2.5 feature; `Servlet-3.0` is the lowest available and serves this branch's Servlet 2.5 WAR. It honors the older `web-app version="2.5"` descriptor and skips annotation scanning, so servlets register from `web-25.xml` (matching the Tomcat behavior on this branch).

### Database setup

If you would like to run the SQL injection tests, the database should be populated as follows. Data files are available in the web applications `spiracle/conf/` directory after the `spiracle.war` file has been deployed and exploded.

> **Note:** When using Docker, database initialisation is handled automatically by the compose stack. Manual setup is only needed for bare-metal deployments.

#### Oracle

1. Ensure that the [Oracle Database JDBC Driver](http://www.oracle.com/technetwork/database/enterprise-edition/jdbc-112010-090769.html) (ojdbc6.jar) is installed in the applications `WEB-INF/lib/` directory after the `spiracle.war` file is exploded on first run.
2. Import the data:

   ```sh
   $ sqlplus SYS/password@//127.0.0.1:1521/XE AS SYSDBA < setupdb_oracle.sql
   ```

   > **Note:** This will create a user `test` with password `test`. You should adjust usernames and/or connection URLs dependent on your environment

3. Configuration parameters for the Oracle JDBC connection are defined in `conf/Spiracle.properties`:

   ```
   c3p0.classname=oracle.jdbc.driver.OracleDriver
   c3p0.url=jdbc:oracle:thin:@localhost:1521:XE
   c3p0.username=test
   c3p0.password=test
   ```

> **Note:** It may be necessary to restart your application server after deploying the `ojdbc6.jar` or updating database configuration.

#### MySQL

1. Import the data:

   ```sh
   $ mysql -u root -p test < setupdb_mysql.sql
   ```

   > **Note:** This will create a user `test` with password `test`. You should adjust usernames and/or connection URLs dependent on your environment

2. Configuration parameters for the MySQL JDBC connection are defined in `conf/Spiracle.properties`:

   ```
   c3p0.classname=com.mysql.jdbc.Driver
   c3p0.url=jdbc:jdbc:mysql://localhost:3306/test
   c3p0.username=test
   c3p0.password=test
   ```

## Running

After deployment, the Spiracle application will be available at:

```
http://ip:port/spiracle/
```

Properties file can be overridden when submitting the request by appending the new value to the URL:

```
&connectionType=c3p0.mysql
```

## Testing

Spiracle ships with a [Hurl](tests/hurl/README.md) test harness under `tests/hurl/`. Tests are endpoint-based and run against any deployment (Docker or bare-metal).

### Suites

| Suite | What it covers |
|---|---|
| `smoke/` | App root responds 200; benign query returns data; SQLi widens result set |
| `functional/` | SendRedirect, SQL queries, reflected XSS via `customTag.jsp`, path traversal, 404/empty-result/no-param negative cases |

### Quick run (plain Docker stack)

```sh
# Bring up MySQL stack
$ docker compose -f docker-compose.mysql.yml up -d

# Smoke
$ ./tests/hurl/run.sh smoke localhost 8080

# Functional
$ ./tests/hurl/run.sh functional localhost 8080
```

Full harness reference: [tests/hurl/README.md](tests/hurl/README.md)

## Building

Prerequisites:

- Java 8 toolchain (compiles `-source 1.4 -target 1.4`; this branch targets Java 1.4 source level with a Servlet 2.5 descriptor)
- Apache Maven
- [Oracle Database JDBC Driver](http://www.oracle.com/technetwork/database/enterprise-edition/jdbc-112010-090769.html) (ojdbc6.jar)

If you wish to use the database features, ensure that the Oracle database JDBC driver file `ojdbc6.jar` is available under `./src/main/webapp/WEB-INF/lib`

### Build flags

Two flags parameterise the build:

- **`-Dversion.jdk=<level>`** — Sets the Java source and target compiler level. On this branch the only supported value is `1.4`.
- **`-Dversion.webxml=<25|30>`** — Selects the Servlet descriptor version. On this branch use `25` (Servlet 2.5 — `@WebServlet` annotations are not available in Java 1.4).

> **Note:** `version.jdk` has no default; `mvn install` without `-Dversion.jdk` fails because the literal `${version.jdk}` is passed to the compiler. Always pass the flag.

Representative invocation:

```sh
# Java 1.4, Servlet 2.5 (required for this branch)
$ mvn install -Dversion.jdk=1.4 -Dversion.webxml=25
```

To clean the build infrastructure, run:

```sh
$ mvn clean
```

The WAR file will be output to:

```
./target/spiracle.war
```

### Toolchain

This branch builds under a Java 8 toolchain with `-source 1.4 -target 1.4`. The Docker image pins its own JDK via its base image (`maven:3.9-eclipse-temurin-8`) — no local JDK is needed when building through Docker.

> **Note:** Unlike `master`, the `java4` branch carries no `mise.toml`; install a Java 8 JDK and Maven yourself, or build via Docker.

### Branch model

- **`java4` (this branch)** — Java 1.4 source-compatible variant. Servlets registered in `web-25.xml` instead of `@WebServlet` annotations. Legacy WAR dependency set: Servlet 2.4 API, Spring 2.5.6, JSTL 1.0, `mysql-connector 3.1.14`, `jTDS 1.2`. MySQL compose stack pins `mysql:5.7` because the legacy connector cannot negotiate MySQL 8's `utf8mb4`. (At runtime the Docker image supplies modern JDBC drivers in Tomcat's `lib/`; see the JDBC-drivers note under [Docker](#docker-quickstart) for which driver each database actually uses.)
- **`master`** — Modern, parameterised source tree. Java 5–8 source level. Use `-Dversion.jdk` to select. Switch to `master` if you do not need Java 1.4 source compatibility.

## Recent fixes

- **#8** — `Content-Type: text/plain` is now set on the `SendRedirect` fallback response (no-parameter case).
- **#33** — `setupdb_mysql.sql` is idempotent; uses `IF [NOT] EXISTS` guards so re-running does not error.
- **#103** — Oracle connection NPE fixed in `CreateC3p0Connection`; was reading non-existent property keys from `Spiracle.properties`. Java 1.4 adaptation: uses `length() == 0` instead of `String.isEmpty()` (added in Java 6).

## License

```
Copyright 2018 Waratek Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
