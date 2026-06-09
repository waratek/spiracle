# Multi-version testing (Java 6 – 25) from one Dockerfile

The Waratek RASP agent supports **Java 6 through 25**. To prove the
SQL-injection matrix (`tests/hurl/rasp`, 440 cases) blocks on every one of those
runtimes, Spiracle builds and runs under any Java version **without a Dockerfile
per version**. A single parameterised `Dockerfile` is driven by five build args;
a small matrix in `scripts/rasp-matrix.sh` maps a Java version onto those args.

```
scripts/rasp-matrix.sh   ── matrix: Java 6..25 → build args
        │
        ├─ docker-compose.<db>.yml        (build.args from env)
        ├─ docker-compose.rasp-agent.yml  (attaches the Waratek agent)
        └─ Dockerfile                     (ARG-parameterised, one file)
```

## The two axes

"Run on Java N" is ambiguous — two things vary independently, and the matrix
sets both:

| Axis | Build arg(s) | What it controls |
|---|---|---|
| **Runtime JRE** | `RUNTIME_BASE` | the JVM the agent actually instruments — the real "run on Java N" |
| **Source/target level** | `VERSION_JDK` + `BUILD_JDK` | the bytecode level the WAR is compiled to |

`VERSION_JDK` is fed to Maven as `-Dversion.jdk` (the pom's
`maven.compiler.source`/`target`). Its spelling flips at Java 9: `1.6`, `1.7`,
`1.8`, then bare `9` … `25`.

## The build args

| Arg | Default | Meaning |
|---|---|---|
| `BUILD_JDK` | `8` | JDK image used to **compile** (`maven:3.9-eclipse-temurin-${BUILD_JDK}`) |
| `VERSION_JDK` | `1.8` | `-Dversion.jdk` source/target level |
| `VERSION_WEBXML` | `30` | Servlet descriptor (25 or 30) |
| `RUNTIME_BASE` | `eclipse-temurin:8-jre` | JRE image the app runs on |
| `TOMCAT_MAJOR` | `9` | Tomcat major line |
| `TOMCAT_VERSION` | `9.0.118` | Tomcat patch (installed from `archive.apache.org`) |

The defaults reproduce the historical Java 8 / Tomcat 9 image, so a plain
`docker compose build` is unchanged.

### Why the runtime is "JRE base + assembled Tomcat"

Docker Hub only publishes `tomcat:9-jreN` tags for **LTS** JREs (8, 11, 17, 21).
Instead, the **build stage** downloads Tomcat from the Apache archive
(`archive.apache.org`, which keeps every patch — `dlcdn` keeps only the latest),
explodes the WAR into it with `jar`, and drops in the JDBC drivers. The runtime
stage then just `COPY`s that self-contained Tomcat onto a plain JRE image and
installs **nothing** — no apt/curl/unzip. This makes the runtime uniform for
every Java the base ships (Temurin 8–25) *and* works on legacy bases whose
package repos are dead (the Azul Zulu 6/7 images used for the tail).

## The version matrix

`scripts/rasp-matrix.sh matrix <JAVA>` resolves a version. Bands:

| Java | `VERSION_JDK` | `BUILD_JDK` | `RUNTIME_BASE` | Tomcat |
|---|---|---|---|---|
| 6 | `1.6` | 8 | `azul/zulu-openjdk:6` | 7.0.x |
| 7 | `1.7` | 8 | `azul/zulu-openjdk:7` | 8.5.x |
| 8 | `1.8` | 8 | `eclipse-temurin:8-jre` | 9.0.x |
| 9–10 | `9`/`10` | 11 | `eclipse-temurin:11-jre` | 9.0.x |
| 11 | `11` | 11 | `eclipse-temurin:11-jre` | 9.0.x |
| 12–16 | `12`…`16` | 17 | `eclipse-temurin:17-jre` | 9.0.x |
| 17 | `17` | 17 | `eclipse-temurin:17-jre` | 9.0.x |
| 18–20 | `18`…`20` | 21 | `eclipse-temurin:21-jre` | 9.0.x |
| 21 | `21` | 21 | `eclipse-temurin:21-jre` | 9.0.x |
| 22–24 | `22`…`24` | 25 | `eclipse-temurin:${N}-jre` | 9.0.x |
| 25 | `25` | 25 | `eclipse-temurin:25-jre` | 9.0.x |

**Why a `BUILD_JDK` band and not one JDK?** `javac` drops old `-source/-target`
support over time (target 1.6 needs JDK ≤ 11; target 25 needs JDK 25). Five LTS
build JDKs cover the whole range. The non-LTS rows compile at their exact level
but **run** on the nearest LTS JRE that hosts that bytecode (e.g. Java 13 → built
with JDK 17, runs on `temurin:17-jre`) because Temurin has no `13-jre` image. Set
`RUNTIME_BASE` yourself (BellSoft Liberica, SapMachine, …) if you need the exact
non-LTS JRE.

## Caveats / edges

- **Java 6 & 7 (the tail)** — Tomcat 9 and Temurin both floor at Java 8, so the
  tail runs **Tomcat 7/8 on an Azul Zulu JRE 6/7 base** (Azul still publishes
  these; Temurin/Docker-official do not). `ojdbc8`/`mssql-jdbc.jre8` need Java 8+
  and won't load there, so **only MySQL works on 6/7**. **Both 6 and 7 are
  verified end-to-end** — build + agent attach + rasp/mysql 139/139 → 550 — after
  three fixes that the tail surfaced:
    1. **Build** — `zulu:6`'s base OS has dead apt repos, so installing packages
       in the runtime stage failed. The Dockerfile now assembles Tomcat entirely
       in the **build stage** and `COPY`s it in; the runtime stage installs
       nothing, so any JRE base works.
    2. **Deploy** — `SpiracleInit` eagerly `Class.forName`s every JDBC driver but
       caught only `ClassNotFoundException`. The Java-8 drivers throw
       `UnsupportedClassVersionError` (a `LinkageError`) on JRE 6/7, which made
       Tomcat 8.5 fail the context ("One or more listeners failed to start";
       Tomcat 9 tolerated it). Broadened to `catch (Throwable)`.
    3. **Connect** — JRE 6 speaks only TLS 1.0, but `mysql:8.0` requires TLS 1.2+,
       so the SSL handshake died (`SSLException: protocol_version`). The mysql URL
       now sets `useSSL=false` (fine for the local throwaway DB; harmless on 8–25).
  The agent attaches on JRE 6/7 because `compiler-8.jar` covers the 6–8 tier
  (the bundle ships `compiler-{8,17,21,25}.jar`).
- **Non-LTS old versions (9, 10, 12–16, 18–20)** have no Temurin JRE image; the
  matrix runs them on the nearest LTS JRE. Override `RUNTIME_BASE` for an exact
  JRE.
- **`tomcat:9-jre25`** may not be published; the tarball-install path sidesteps
  this — only `eclipse-temurin:25-jre` must exist (it does).
- **rasp suite DB coverage** — `tests/hurl/rasp/` ships matrices for **MySQL
  (139) and Oracle (301)** only; there is no MSSQL rasp suite. The agent rule is
  `vendor(any)`, so MSSQL injection would be blocked too, but the MSSQL Docker
  stack (`docker-compose.mssql.yml`) currently fails to seed in this environment
  (`db-init`: SA login fails → `spiracle` DB not created) — a pre-existing stack
  issue independent of this work.

## The agent

The RASP suite needs the Waratek agent attached. The agent binary is **not** in
this repo. `scripts/rasp-matrix.sh setup-agent` copies a prepared agent
(`AGENT_SRC`, default `../agent-test`) to `AGENT_DIR` (default `../agent-run`)
and writes:

- a **standalone** `waratek.properties` (`com.waratek.ControllerPresent=false`)
  so the agent runs headless with local rules — no Portal/controller needed;
- a **SQL-injection PROTECT** `rules.armr`:

  ```
  sql("Block SQL injection from HTTP, any vendor"):
      vendor(any)
      input(http)
      injection(successful-attempt, failed-attempt)
      protect(message: "...", severity: Very-High)
  endsql
  ```

  The block message is hardcoded in the agent and surfaced as a
  `java.sql.SQLException` only on a `protect` action; Spiracle's
  `SelectUtil.verifySQLException` maps that exact message to **HTTP 550**, which
  the rasp suite asserts.

`docker-compose.rasp-agent.yml` mounts `AGENT_DIR` at `/opt/waratek` and sets
`CATALINA_OPTS=-javaagent:/opt/waratek/waratek.jar …`.

## Usage

```sh
# Inspect the resolved args for a version
./scripts/rasp-matrix.sh matrix 17

# Build only
./scripts/rasp-matrix.sh build 21 mysql

# Build + attach agent + run the rasp suite + tear down
./scripts/rasp-matrix.sh test 17 mysql
./scripts/rasp-matrix.sh test 21 oracle

# Sweep several versions and print a PASS/FAIL summary
./scripts/rasp-matrix.sh sweep "8 11 17 21 25" mysql

# No agent: smoke + functional on a plain deployment
./scripts/rasp-matrix.sh plain 17 mysql
```

Environment overrides: `AGENT_SRC`, `AGENT_DIR`, `HURL_LIBS` (dir holding
`libxml2.so.2` etc. for the `hurl` binary), `KEEP_UP=1` (leave the stack up).

## Files

| File | Role |
|---|---|
| `Dockerfile` | one parameterised build (5 ARGs) |
| `docker-compose.{mysql,oracle,mssql}.yml` | `build.args` wired to env vars |
| `docker-compose.rasp-agent.yml` | overlay that attaches the agent |
| `scripts/rasp-matrix.sh` | matrix + build/test/sweep driver |
