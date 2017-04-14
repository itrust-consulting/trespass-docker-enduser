#!/bin/bash

# Get the list of database to create from command line argument. If not, attribute default value
LIST_DBS=$1
LIST_DBS=${LIST_DBS:-FE,REDMINE,ARGUESECURE}

# Declare array for each default database
declare -A CREATEDB
CREATEDB[FE]="CREATE DATABASE IF NOT EXISTS $FE_DB_NAME;"
CREATEDB[REDMINE]="CREATE DATABASE IF NOT EXISTS $REDMINE_DB_NAME;"
CREATEDB[ARGUESECURE]="CREATE DATABASE IF NOT EXISTS $ARGUESECURE_DB_NAME;"

declare -A CREATEUSER
CREATEUSER[FE]="CREATE USER '$FE_DB_USER'@'172.17.0.%' IDENTIFIED BY '$FE_DB_PASS';"
CREATEUSER[REDMINE]="CREATE USER '$REDMINE_DB_USER'@'172.17.0.%' IDENTIFIED BY '$REDMINE_DB_PASS';"
CREATEUSER[ARGUESECURE]="CREATE USER '$ARGUESECURE_DB_USER'@'172.17.0.%' IDENTIFIED BY '$ARGUESECURE_DB_PASS';"

declare -A GRANTPRIV
GRANTPRIV[FE]="GRANT ALL PRIVILEGES ON $FE_DB_NAME.* TO '$FE_DB_USER'@'172.17.0.%';"
GRANTPRIV[REDMINE]="GRANT ALL PRIVILEGES ON $REDMINE_DB_NAME.* TO '$REDMINE_DB_USER'@'172.17.0.%';"
GRANTPRIV[ARGUESECURE]="GRANT ALL PRIVILEGES ON $ARGUESECURE_DB_NAME.* TO '$ARGUESECURE_DB_USER'@'172.17.0.%';"

# Loop on list of db given by user, create SQL script, execute it, and delete it
for DB in $(echo $LIST_DBS | sed "s/,/ /g"); do
echo "Creating script for $DB database"
cat << EOF > /tmp/init-script.sql
${CREATEDB[$(echo $DB)]}
${CREATEUSER[$(echo $DB)]}
${GRANTPRIV[$(echo $DB)]}
EOF
echo "Executing script"
mysql -uroot < /tmp/init-script.sql
echo "Deleting script"
rm /tmp/init-script.sql
done
