#!/bin/zsh

sqlplus -s sakila/sakila@//localhost/XEPDB1 @/step_1.sql
sqlplus -s sakila/sakila@//localhost/XEPDB1 @/step_2.sql