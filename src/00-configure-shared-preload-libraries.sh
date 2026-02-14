#!/bin/bash
set -e
if [ -f "${PGDATA}/postgresql.conf" ]; then
  if grep -q "^shared_preload_libraries" "${PGDATA}/postgresql.conf"; then
    # Add pg_search if not present
    if ! grep -q "pg_search" "${PGDATA}/postgresql.conf"; then
      sed -i "s/shared_preload_libraries = '\(.*\)'/shared_preload_libraries = '\1, pg_search'/" "${PGDATA}/postgresql.conf"
    fi
    # Add age if not present
    if ! grep -q "age" "${PGDATA}/postgresql.conf"; then
      sed -i "s/shared_preload_libraries = '\(.*\)'/shared_preload_libraries = '\1, age'/" "${PGDATA}/postgresql.conf"
    fi
  else
    echo "shared_preload_libraries = 'pg_search, age'" >> "${PGDATA}/postgresql.conf"
  fi
fi
