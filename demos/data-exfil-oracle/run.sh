#!/bin/zsh
docker run --name oracle -d -p 1521:1521 -e ORACLE_PASSWORD=sakila -e APP_USER=sakila -e APP_USER_PASSWORD=sakila jasonumiker/oracle-sakila:latest