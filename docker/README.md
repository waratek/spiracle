# Spiracle — Docker usage

**WARNING: Spiracle is an intentionally-vulnerable application. Run on localhost / throwaway networks only. Never expose to the internet.**

## Prerequisites

- Docker Engine 24+ with the Compose v2 plugin (`docker compose`)
- No local Tomcat or database installation needed

## Quick start

Pick one database and run the corresponding compose file from the repo root.

### MySQL (recommended for first run — smallest image)

```sh
docker compose -f docker-compose.mysql.yml up --build
```

Browse to: http://localhost:8080/spiracle/

Tear down (removes volumes):
```sh
docker compose -f docker-compose.mysql.yml down -v
```

### Microsoft SQL Server

```sh
docker compose -f docker-compose.mssql.yml up --build
```

SQL Server image (~1.5 GB). A one-shot `db-init` service seeds the database after SQL Server becomes healthy.

Browse to: http://localhost:8080/spiracle/

```sh
docker compose -f docker-compose.mssql.yml down -v
```

### Oracle XE

```sh
docker compose -f docker-compose.oracle.yml up --build
```

Oracle XE image (~2–4 GB). First pull takes several minutes. The container has a long startup; wait for the `db` service to show `healthy` before the app becomes ready.

Browse to: http://localhost:8080/spiracle/

```sh
docker compose -f docker-compose.oracle.yml down -v
```

## How it works

- A multi-stage Dockerfile builds the WAR with JDK 8 / Maven (`-Dversion.jdk=1.4 -Dversion.webxml=25`), then deploys it on Tomcat 9.
- MySQL (Connector/J 5.1.49), MSSQL (mssql-jdbc 12.4.2.jre8) and Oracle (ojdbc8 21.13) JDBC drivers are placed in Tomcat's `lib/`.
- The `java4` WAR additionally bundles the legacy `mysql-connector 3.1.14` and `jTDS 1.2` in `WEB-INF/lib`. The webapp classloader prefers `WEB-INF/lib`, so the running MySQL driver is the WAR's `3.1.14` (hence the `mysql:5.7` pin), **not** the `5.1.49` in Tomcat's `lib/`. For MSSQL and Oracle the app targets the Tomcat-lib drivers — `Spiracle.properties` configures `com.microsoft.sqlserver.jdbc.SQLServerDriver` and `oracle.jdbc.driver.OracleDriver`, so the WAR's `jTDS` jar is unused at runtime.
- `docker/entrypoint.sh` rewrites `conf/Spiracle.properties` from environment variables before Tomcat starts. The committed `Spiracle.properties` is never modified.

## Environment variables (app service)

| Variable | Purpose | Example |
|---|---|---|
| `SPIRACLE_DEFAULT_CONNECTION` | Sets `default.connection` in properties | `c3p0.mysql` |
| `SPIRACLE_DB_HOST` | Replaces `localhost` in the chosen db URL | `db` |
| `SPIRACLE_DB_URL` | Overrides the entire URL line (Oracle service-name form) | `jdbc:oracle:thin:@//db:1521/XEPDB1` |
