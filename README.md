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

The multi-stage `Dockerfile` builds the WAR with JDK 8 / Maven (`-Dversion.jdk=1.6 -Dversion.webxml=30`) and deploys it on Tomcat 9. `docker/entrypoint.sh` rewrites `conf/Spiracle.properties` from environment variables at startup.

> **Note — JDBC drivers:** No JDBC driver is bundled in the WAR. The Docker image places the drivers in Tomcat's `lib/`: MySQL Connector/J 5.1.49 (legacy `com.mysql.jdbc.Driver` classname), MSSQL `mssql-jdbc` 12.4.2.jre8, and Oracle `ojdbc8` 21.13. The MySQL stack runs `mysql:8.0` (`--default-authentication-plugin=mysql_native_password`, which Connector/J 5.1.49 can negotiate).

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

| Suite | Agent required | What it covers |
|---|---|---|
| `smoke/` | No | App root responds 200; benign query returns data; unblocked SQLi widens result set (confirming injections succeed without agent) |
| `functional/` | No | SendRedirect, SQL queries, reflected XSS via `customTag.jsp`, path traversal, 404/empty-result/no-param negative cases |
| `rasp/` | Yes (Waratek RASP) | 579-case SQL injection matrix (139 MySQL, 301 Oracle, 139 MSSQL); asserts status `550`, which is only emitted when the Waratek agent intercepts the query |

> **Note:** The `rasp/` suite requires the Waratek RASP agent attached to Tomcat. The agent supports Java 6 through 25, which is why this matrix lives on `master` (Java 6+) and not on the `java4`/`java5` branches.

To build and run the rasp suite across the whole Java 6–25 range from a single parameterised `Dockerfile`, use `scripts/rasp-matrix.sh` (e.g. `./scripts/rasp-matrix.sh test 17 mysql` or `./scripts/rasp-matrix.sh sweep "8 11 17 21 25" mysql`). See [docs/multi-version-testing.md](docs/multi-version-testing.md) for the design and the version matrix.

### Quick run (plain Docker stack)

```sh
# Bring up MySQL stack
$ docker compose -f docker-compose.mysql.yml up -d

# Smoke
$ ./tests/hurl/run.sh smoke localhost 8080

# Functional
$ ./tests/hurl/run.sh functional localhost 8080
```

The `rasp/` suite will fail on a plain deployment — expected. Run it only with the Waratek agent attached to Tomcat.

Full harness reference: [tests/hurl/README.md](tests/hurl/README.md)

## Building

Prerequisites:

- Java 8 toolchain (compiles `-source/-target` from `1.6` upward)
- Apache Maven
- [Oracle Database JDBC Driver](http://www.oracle.com/technetwork/database/enterprise-edition/jdbc-112010-090769.html) (ojdbc6.jar)

If you wish to use the database features, ensure that the Oracle database JDBC driver file `ojdbc6.jar` is available under `./src/main/webapp/WEB-INF/lib`

### Build flags

Two flags parameterise the build:

- **`-Dversion.jdk=<level>`** — Sets the Java source and target compiler level. Supported values on `master`: `1.6`, `1.7`, `1.8`. (Java 6 is the floor: the Waratek RASP agent supports Java 6 through 25, so the protected matrix targets Java 6+.)
- **`-Dversion.webxml=<25|30>`** — Selects the Servlet descriptor version. `30` (Servlet 3.0) registers servlets from the `@WebServlet` annotations; `25` (Servlet 2.5) registers them explicitly from `web-25.xml`.

> **Note:** `version.jdk` has no default; `mvn install` without `-Dversion.jdk` fails because the literal `${version.jdk}` is passed to the compiler. Always pass the flag.

Representative invocations:

```sh
# Java 8, Servlet 3.0 (recommended)
$ mvn install -Dversion.jdk=1.8 -Dversion.webxml=30

# Java 6, Servlet 3.0 (minimum supported level)
$ mvn install -Dversion.jdk=1.6 -Dversion.webxml=30
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

This branch builds under a Java 8 toolchain. The Docker image pins its own JDK via its base image (`maven:3.9-eclipse-temurin-8`) — no local JDK is needed when building through Docker.

### Branch model

- **`master` (this branch)** — Modern, parameterised source tree. Java 6+ source level (`-Dversion.jdk=1.6|1.7|1.8`). The only branch the Waratek RASP suite runs against, since the agent supports Java 6 through 25.
- **`java5`** — Java 5 source-compatible variant (same source tree, built at `-Dversion.jdk=1.5`). No RASP suite — the agent does not support Java 5.
- **`java4`** — Java-1.4-source-compatible variant. Annotations replaced by `web.xml` registration; uses a legacy dependency set. Check out this branch if you need Java 4 compatibility.

## Recent fixes

- **#8** — `Content-Type: text/plain` is now set on the `SendRedirect` fallback response (no-parameter case).
- **#33** — `setupdb_mysql.sql` is idempotent; uses `IF [NOT] EXISTS` guards so re-running does not error.
- **#103** — Oracle connection NPE fixed in `CreateC3p0Connection`; was reading non-existent property keys from `Spiracle.properties`.

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
