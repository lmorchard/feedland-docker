#!/bin/bash
# Wrapper script to run setup.sql, skipping the CREATE DATABASE line
# since the MySQL container already creates the database

set -e

echo "Running FeedLand schema initialization..."

# Skip the first two lines (CREATE DATABASE and USE feedland)
# The database is already created and selected by the MySQL entrypoint
tail -n +3 /setup.sql | mysql -u root -p"${MYSQL_ROOT_PASSWORD}" feedland

echo "FeedLand schema initialized successfully."
