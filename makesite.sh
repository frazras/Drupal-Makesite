#!/bin/bash
 
EXPECTED_ARGS=1
E_BADARGS=65
MYSQL=`which mysql`
DRUSH=`which drush`
DBUSER='root'
DBPASS='root'
VER='7.x'
 
U1="CREATE USER 'user_$1'@'localhost' IDENTIFIED BY  '^#!$1xYz';"
U2="GRANT USAGE ON * . * TO 'user_$1'@'localhost' IDENTIFIED BY '^#!$1xYz' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"
Q1="CREATE DATABASE IF NOT EXISTS site_$1;"
Q2="GRANT ALL PRIVILEGES ON site_$1 . * TO  'user_$1'@'localhost'; "
Q3="FLUSH PRIVILEGES;"
SQL="${U1}${U2}${Q1}${Q2}${Q3}"
 
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 sitename (creates d7 site)"
  exit $E_BADARGS
fi
 
$MYSQL -u"$DBUSER" -p"$DBPASS" -e "$SQL"
 
#$DRUSH dl drupal-"$VER" $2  --drupal-project-rename="$1"
wget  http://dl.dropbox.com/u/8273533/example.make
$DRUSH -v make example.make -y "$1"
cd "$1"
$DRUSH site-install standard --db-url="mysql://user_$1:^#!$1xYz@localhost/site_$1" --site-name="$1" --account-name=webmin --account-pass="^#!$1xYz" --account-mail="$1@exterbox.com" --site-mail="$1@exterbox.com" --yes