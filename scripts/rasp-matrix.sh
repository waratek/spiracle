#!/usr/bin/env bash
# =============================================================================
# rasp-matrix.sh — build & RASP-test Spiracle across Java 6..25 from ONE
# Dockerfile, by resolving each Java version to a set of Docker build args.
#
# The Waratek RASP agent supports Java 6 through 25; this script lets you run
# the 440-case SQL-injection matrix (tests/hurl/rasp) against the app on any
# of those runtimes without maintaining a Dockerfile per version.
#
# COMMANDS
#   matrix <JAVA>              Print the resolved build args for a Java version.
#   setup-agent               Prepare the agent dir (copy + standalone config).
#   build <JAVA> [db]         Build the image for <JAVA> (db: mysql|oracle|mssql).
#   test  <JAVA> [db]         Build, start db+app+agent, run the rasp suite, tear down.
#   sweep "<JAVA...>" [db]    test each Java version in turn; print a summary.
#   plain <JAVA> [db]         Like test but NO agent (runs smoke+functional instead).
#
# ENV OVERRIDES
#   AGENT_SRC   source agent dir to copy        (default: ../agent-test)
#   AGENT_DIR   prepared agent dir (mounted)     (default: ../agent-run)
#   HURL_LIBS   dir with libxml2.so.2 etc.       (default: ~/.local/hurl-libs)
#   KEEP_UP=1   do not tear the stack down after test
#
# EXAMPLES
#   ./scripts/rasp-matrix.sh test 17 mysql
#   ./scripts/rasp-matrix.sh sweep "8 11 17 21" mysql
#   ./scripts/rasp-matrix.sh sweep "8 11 17 21" oracle
#
# See docs/multi-version-testing.md for the design and the matrix rationale.
# =============================================================================
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO"

AGENT_SRC="${AGENT_SRC:-$REPO/../agent-test}"
AGENT_DIR="${AGENT_DIR:-$REPO/../agent-run}"
HURL_LIBS="${HURL_LIBS:-$HOME/.local/hurl-libs}"

# ---------------------------------------------------------------------------
# Version matrix: Java level -> (BUILD_JDK, VERSION_JDK, RUNTIME_BASE,
# TOMCAT_MAJOR, TOMCAT_VERSION). Emitted as KEY=VALUE lines.
#
#  * BUILD_JDK bands: one JDK cannot target every source level, so pick the
#    oldest LTS JDK that still supports the target (8 -> 6/7/8, 11 -> 9/10/11,
#    17 -> 12..17, 21 -> 18..21, 25 -> 22..25).
#  * VERSION_JDK: 6/7/8 use the legacy 1.x spelling; 9+ are bare numbers.
#  * RUNTIME_BASE: a plain JRE image; Tomcat 9 is installed from the archive.
#    Eclipse Temurin publishes JRE images for 8/11/17/21 and recent (22..25).
#    Non-LTS old versions (9,10,12..16,18..20) have no Temurin JRE image — they
#    are marked best-effort and will need a different vendor base (set
#    RUNTIME_BASE yourself, e.g. a BellSoft Liberica or SapMachine image).
#  * Java 6/7: Tomcat 9 needs Java 8+, so the tail drops to Tomcat 7/8 on a
#    legacy JRE 6/7 image you must supply (RUNTIME_BASE), and ojdbc8/mssql-jdbc
#    (Java 8+) won't load — only MySQL works there.
# ---------------------------------------------------------------------------
matrix() {
    local j="$1" build vjdk base tmaj tver note=""
    case "$j" in
        6)  build=8;  vjdk=1.6; base="azul/zulu-openjdk:6";     tmaj=7; tver=7.0.109; note="tail: Azul Zulu JRE6 + Tomcat7; MySQL only (ojdbc8/mssql-jdbc need Java 8+)";;
        7)  build=8;  vjdk=1.7; base="azul/zulu-openjdk:7";     tmaj=8; tver=8.5.100; note="tail: Azul Zulu JRE7 + Tomcat8.5; MySQL only (ojdbc8/mssql-jdbc need Java 8+)";;
        8)  build=8;  vjdk=1.8; base="eclipse-temurin:8-jre";    tmaj=9; tver=9.0.118;;
        9)  build=11; vjdk=9;   base="eclipse-temurin:11-jre";   tmaj=9; tver=9.0.118; note="non-LTS: runs on JRE11 (no temurin:9-jre)";;
        10) build=11; vjdk=10;  base="eclipse-temurin:11-jre";   tmaj=9; tver=9.0.118; note="non-LTS: runs on JRE11";;
        11) build=11; vjdk=11;  base="eclipse-temurin:11-jre";   tmaj=9; tver=9.0.118;;
        12|13|14|15|16) build=17; vjdk="$j"; base="eclipse-temurin:17-jre"; tmaj=9; tver=9.0.118; note="non-LTS: runs on JRE17";;
        17) build=17; vjdk=17;  base="eclipse-temurin:17-jre";   tmaj=9; tver=9.0.118;;
        18|19|20) build=21; vjdk="$j"; base="eclipse-temurin:21-jre"; tmaj=9; tver=9.0.118; note="non-LTS: runs on JRE21";;
        21) build=21; vjdk=21;  base="eclipse-temurin:21-jre";   tmaj=9; tver=9.0.118;;
        22|23|24) build=25; vjdk="$j"; base="eclipse-temurin:${j}-jre"; tmaj=9; tver=9.0.118; note="non-LTS: temurin:${j}-jre may be unavailable";;
        25) build=25; vjdk=25;  base="eclipse-temurin:25-jre";   tmaj=9; tver=9.0.118;;
        *)  echo "ERROR: unsupported Java version '$j' (expected 6..25)" >&2; return 1;;
    esac
    # JDK 16+ strongly encapsulates the JDK internals the legacy Maven plugins
    # reflect into; open them so the build runs. Harmless to omit on 8/11.
    local mopts=""
    if [ "$build" -ge 16 ] 2>/dev/null; then
        mopts="--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.text=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.desktop/java.awt.font=ALL-UNNAMED"
    fi
    cat <<EOF
BUILD_JDK=$build
VERSION_JDK=$vjdk
VERSION_WEBXML=30
RUNTIME_BASE=$base
TOMCAT_MAJOR=$tmaj
TOMCAT_VERSION=$tver
MAVEN_OPTS=$mopts
MATRIX_NOTE=$note
EOF
}

# Resolve the matrix into the current environment for `docker compose`.
load_matrix() {
    local j="$1" line
    while IFS= read -r line; do export "$line"; done < <(matrix "$j")
    [ -n "${MATRIX_NOTE:-}" ] && echo "note (Java $j): $MATRIX_NOTE" >&2 || true
}

# ---------------------------------------------------------------------------
# Agent preparation: copy the pristine agent, write a standalone (no-controller)
# waratek.properties and a SQL-injection PROTECT rule that makes blocked queries
# return HTTP 550 (the message is hardcoded in the agent; `protect` triggers it).
# ---------------------------------------------------------------------------
setup_agent() {
    [ -f "$AGENT_SRC/waratek.jar" ] || { echo "ERROR: no waratek.jar under AGENT_SRC=$AGENT_SRC" >&2; return 1; }
    echo "Preparing agent: $AGENT_SRC -> $AGENT_DIR"
    rm -rf "$AGENT_DIR"; mkdir -p "$AGENT_DIR"
    cp -a "$AGENT_SRC/." "$AGENT_DIR/"
    rm -f "$AGENT_DIR/instance.waratek.properties.lock" "$AGENT_DIR/rules.log" "$AGENT_DIR/events.log"

    cat > "$AGENT_DIR/waratek.properties" <<'PROPS'
# Standalone (headless) — no controller, local ARMR rules only.
com.waratek.ControllerPresent=false
com.waratek.ControllerUnavailableAction=ignore
com.waratek.rules.local=/opt/waratek/rules.armr
com.waratek.log.file=/opt/waratek/events.log
com.waratek.rules.autoreload=true
com.waratek.ShowStart=true
PROPS

    cat > "$AGENT_DIR/rules.armr" <<'ARMR'
app("Spiracle SQLi protect"):
	requires(version: ARMR/2.12)
	sql("Block SQL injection from HTTP, any vendor"):
		vendor(any)
		input(http)
		injection(successful-attempt, failed-attempt)
		protect(message: "SQL injection blocked", severity: Very-High)
	endsql
endapp
ARMR
    echo "Agent ready at $AGENT_DIR (ControllerPresent=false, SQLi protect rule installed)."
}

hurl() { LD_LIBRARY_PATH="$HURL_LIBS" command hurl "$@"; }

compose_files() {  # echoes -f args for a db, optionally + agent overlay
    local db="$1" agent="${2:-}"
    printf -- '-f %s ' "$REPO/docker-compose.${db}.yml"
    [ "$agent" = agent ] && printf -- '-f %s ' "$REPO/docker-compose.rasp-agent.yml"
}

wait_app() {  # wait for app root 200 (default 120s)
    local i=0 max="${1:-40}"
    until [ "$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/spiracle/ 2>/dev/null)" = 200 ] || [ $i -ge "$max" ]; do
        i=$((i+1)); sleep 3
    done
    [ "$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/spiracle/ 2>/dev/null)" = 200 ]
}

build() {  # build <JAVA> [db]
    local j="$1" db="${2:-mysql}"
    load_matrix "$j"
    echo "==> build Java $j (BUILD_JDK=$BUILD_JDK VERSION_JDK=$VERSION_JDK RUNTIME_BASE=$RUNTIME_BASE Tomcat $TOMCAT_VERSION)"
    docker compose $(compose_files "$db") build app
}

test_version() {  # test <JAVA> [db]  — with agent + rasp suite
    local j="$1" db="${2:-mysql}"
    local proj="rasp${j}_$$"
    load_matrix "$j"
    setup_agent
    echo "==> Java $j / $db : build + up (agent attached)"
    AGENT_DIR="$AGENT_DIR" docker compose -p "$proj" $(compose_files "$db" agent) up -d --build
    local rc=0
    if wait_app; then
        echo "==> app ready; running rasp/$db"
        if hurl --test --variables-file "$REPO/tests/hurl/rasp/protected.env" \
                --variable host=localhost --variable port=8080 --variable block_status=550 \
                "$REPO"/tests/hurl/rasp/${db}/*.hurl; then
            echo "RESULT Java $j ($db): PASS"
        else
            echo "RESULT Java $j ($db): FAIL (rasp assertions)"; rc=1
        fi
    else
        echo "RESULT Java $j ($db): FAIL (app did not become ready)"; rc=1
        AGENT_DIR="$AGENT_DIR" docker compose -p "$proj" $(compose_files "$db" agent) logs app | tail -50 || true
    fi
    if [ "${KEEP_UP:-0}" = 1 ]; then
        echo "KEEP_UP=1 — leaving stack '$proj' running"
    else
        AGENT_DIR="$AGENT_DIR" docker compose -p "$proj" $(compose_files "$db" agent) down -v >/dev/null 2>&1 || true
    fi
    return $rc
}

plain_version() {  # plain <JAVA> [db] — no agent; smoke+functional
    local j="$1" db="${2:-mysql}"
    local proj="plain${j}_$$"
    load_matrix "$j"
    echo "==> Java $j / $db : build + up (no agent)"
    docker compose -p "$proj" $(compose_files "$db") up -d --build
    local rc=0
    if wait_app; then
        hurl --test --variables-file "$REPO/tests/hurl/smoke/local.env" \
             --variable host=localhost --variable port=8080 "$REPO"/tests/hurl/smoke/*.hurl \
          && hurl --test --variables-file "$REPO/tests/hurl/functional/local.env" \
             --variable host=localhost --variable port=8080 "$REPO"/tests/hurl/functional/*.hurl \
          && echo "RESULT Java $j ($db, plain): PASS" || { echo "RESULT Java $j ($db, plain): FAIL"; rc=1; }
    else
        echo "RESULT Java $j ($db, plain): FAIL (app not ready)"; rc=1
    fi
    [ "${KEEP_UP:-0}" = 1 ] || docker compose -p "$proj" $(compose_files "$db") down -v >/dev/null 2>&1 || true
    return $rc
}

sweep() {  # sweep "<JAVA...>" [db]
    local versions="$1" db="${2:-mysql}" v results=""
    for v in $versions; do
        if test_version "$v" "$db"; then results="$results\nJava $v ($db): PASS"
        else results="$results\nJava $v ($db): FAIL"; fi
    done
    echo "==================== SWEEP SUMMARY ($db) ===================="
    echo -e "$results"
}

# Full matrix: smoke+functional + rasp/mysql on every distinct runtime band,
# plus rasp/oracle and rasp/mssql on Java 8+ (those drivers need Java 8+). The
# bands {6,7,8,11,17,21,25} cover every distinct RUNTIME_BASE/BUILD_JDK — the
# non-LTS versions in between share a neighbour's JRE.
full() {
    local mysql_versions="${1:-6 7 8 11 17 21 25}"
    local java8plus="${2:-8 11 17 21 25}"
    local results="" v
    for v in $mysql_versions; do
        if plain_version "$v" mysql; then results="$results\nsmoke+functional  Java $v : PASS"
        else results="$results\nsmoke+functional  Java $v : FAIL"; fi
    done
    for v in $mysql_versions; do
        if test_version "$v" mysql; then results="$results\nrasp mysql        Java $v : PASS"
        else results="$results\nrasp mysql        Java $v : FAIL"; fi
    done
    for v in $java8plus; do
        if test_version "$v" oracle; then results="$results\nrasp oracle       Java $v : PASS"
        else results="$results\nrasp oracle       Java $v : FAIL"; fi
    done
    for v in $java8plus; do
        if test_version "$v" mssql; then results="$results\nrasp mssql        Java $v : PASS"
        else results="$results\nrasp mssql        Java $v : FAIL"; fi
    done
    echo "==================== FULL MATRIX SUMMARY ===================="
    echo -e "$results"
}

usage() { sed -n '2,40p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; }

cmd="${1:-}"; shift || true
case "$cmd" in
    matrix)       matrix "${1:?Java version}";;
    setup-agent)  setup_agent;;
    build)        build "${1:?Java version}" "${2:-mysql}";;
    test)         test_version "${1:?Java version}" "${2:-mysql}";;
    plain)        plain_version "${1:?Java version}" "${2:-mysql}";;
    sweep)        sweep "${1:?versions, e.g. \"8 11 17 21\"}" "${2:-mysql}";;
    full)         full "${1:-}" "${2:-}";;
    ""|-h|--help) usage;;
    *)            echo "unknown command '$cmd'" >&2; usage; exit 2;;
esac
