#!/bin/bash
docker exec -it mysql mysql -psakila -e "use sakila; SELECT c.first_name, c.last_name, c.email, a.address, a.postal_code FROM customer c JOIN address a ON (c.address_id = a.address_id);"