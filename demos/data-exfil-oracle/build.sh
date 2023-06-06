#!/bin/bash
docker build -t jasonumiker/oracle-sakila:050623 .
docker tag jasonumiker/oracle-sakila:050623 jasonumiker/oracle-sakila:latest
docker push jasonumiker/oracle-sakila:050623
docker push jasonumiker/oracle-sakila:latest