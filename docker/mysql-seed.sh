#!/bin/bash
# Docker-only init script for MySQL.
# Loads the canonical schema/seed (idempotent: IF [NOT] EXISTS), then grants
# remote access for the app container.
set -e

mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < /init/setupdb_mysql.sql

# Grant remote access for 'test'@'%' so the app container (different host)
# can connect. The canonical seed only creates 'test'@'localhost'.
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<'SQL'
CREATE USER IF NOT EXISTS 'test'@'%' IDENTIFIED WITH mysql_native_password BY 'test';
GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SQL
