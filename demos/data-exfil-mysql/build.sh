#!/bin/zsh
docker buildx create --name mybuilder --bootstrap --use
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/mysql-sakila:050623 \
  .
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/mysql:latest \
  .
docker buildx rm mybuilder