#!/usr/bin/env bash
docker exec -it oracle sqlplus -s sakila/sakila@//localhost/XEPDB1 @//query.sql