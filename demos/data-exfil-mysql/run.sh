#!/bin/zsh
docker run --name mysql -e MYSQL_ROOT_PASSWORD=sakila -d jasonumiker/mysql-sakila:latest