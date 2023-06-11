docker buildx create --name mybuilder --bootstrap --use
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/security-playground-unprivileged:110623 \
  .
docker buildx build --push \
  --platform linux/arm64,linux/amd64 \
  --tag jasonumiker/security-playground-unprivileged:latest \
  .
docker buildx rm mybuilder