docker buildx create --name buildx --driver-opt network=host --use
docker buildx inspect --bootstrap
docker buildx build -t jasonumiker/dnsloadgen:latest --platform linux/amd64 --platform linux/arm64 --file Dockerfile --push .
docker buildx imagetools inspect jasonumiker/dnsloadgen:latest
docker buildx rm buildx