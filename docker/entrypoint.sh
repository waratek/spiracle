#!/bin/sh
# Rewrite Spiracle.properties from env vars before Tomcat starts.
# All changes are made to the exploded webapp copy only — source files untouched.

PROPS="$CATALINA_HOME/webapps/spiracle/conf/Spiracle.properties"

# SPIRACLE_DEFAULT_CONNECTION — e.g. "c3p0.mysql"
if [ -n "$SPIRACLE_DEFAULT_CONNECTION" ]; then
    sed -i "s|^default\.connection=.*|default.connection=${SPIRACLE_DEFAULT_CONNECTION}|" "$PROPS"
fi

# Derive the db key from the connection name (e.g. c3p0.mysql → mysql)
if [ -n "$SPIRACLE_DEFAULT_CONNECTION" ]; then
    DB_KEY="${SPIRACLE_DEFAULT_CONNECTION#c3p0.}"
else
    DB_KEY=""
fi

# SPIRACLE_DB_URL — override the whole url line for this db (takes priority)
if [ -n "$SPIRACLE_DB_URL" ] && [ -n "$DB_KEY" ]; then
    sed -i "s|^c3p0\.${DB_KEY}\.url=.*|c3p0.${DB_KEY}.url=${SPIRACLE_DB_URL}|" "$PROPS"
elif [ -n "$SPIRACLE_DB_HOST" ] && [ -n "$DB_KEY" ]; then
    # Replace only 'localhost' in the specific db url line
    sed -i "/^c3p0\.${DB_KEY}\.url=/ s|localhost|${SPIRACLE_DB_HOST}|g" "$PROPS"
fi

exec "$CATALINA_HOME/bin/catalina.sh" run
