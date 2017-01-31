#!/bin/bash
mysqld &
sleep 5
echo "Creatubg DB"
mysql -u root -e "CREATE DATABASE mydb"
echo "Dumping DB"
mysql -u root mydb < /tmp/db/dump.sql