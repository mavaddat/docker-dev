#!/bin/bash

# Change into this directory
# Required by the relative paths below
cd $(dirname "$0")


# Decide on tagging
echo -e "\n  ➤  Which tag would you like to push to? [default: latest]"
read -p "== " TAG

if [[ -z "$TAG" ]]; then
  TAG="latest"
fi


# Setup build servers
#   - arm64 is built locally on Apple Silicon
#   - amd64 is built remotely on the dev server on x64/Intel hardware
# (If your local machine is x64/Intel hardware then you can reverse these)
docker buildx rm mavaddat # Start from a clean slate
docker buildx create --name mavaddat --use
docker buildx create --name mavaddat --platform linux/amd64 --append ssh://mavaddat@192.168.0.5 # Leverage the dev server


# Let's start building!
docker buildx build --pull -f 80/Dockerfile --platform linux/arm64,linux/amd64 -t phpdockerio/php:8.0-fpm

if [[ ${TAG} != "latest" ]] ; then
  docker tag phpdockerio/php:8.0-fpm
  docker push phpdockerio/php:8.0-fpm
fi

docker buildx build --pull -f 74/Dockerfile --platform linux/arm64,linux/amd64 -t phpdockerio/php:7.4-fpm

if [[ ${TAG} != "latest" ]] ; then
  docker tag phpdockerio/php:7.4-fpm
  docker push phpdockerio/php:7.4-fpm
fi

docker buildx build --pull -f 73/Dockerfile --platform linux/arm64,linux/amd64 -t phpdockerio/php:7.3-fpm

if [[ ${TAG} != "latest" ]] ; then
  docker tag phpdockerio/php:7.3-fpm
  docker push phpdockerio/php:7.3-fpm
fi

docker buildx build --pull -f 72/Dockerfile --platform linux/arm64,linux/amd64 -t phpdockerio/php:7.2-fpm

if [[ ${TAG} != "latest" ]] ; then
  docker tag phpdockerio/php:7.2-fpm
  docker push phpdockerio/php:7.2-fpm
fi

docker buildx build --pull -f 71/Dockerfile --platform linux/arm64,linux/amd64 -t phpdockerio/php:7.1-fpm

if [[ ${TAG} != "latest" ]] ; then
  docker tag phpdockerio/php:7.1-fpm
  docker push phpdockerio/php:7.1-fpm
fi

docker buildx build --pull -f 70/Dockerfile --platform linux/arm64,linux/amd64 -t phpdockerio/php:7.0-fpm

if [[ ${TAG} != "latest" ]] ; then
  docker tag phpdockerio/php:7.0-fpm
  docker push phpdockerio/php:7.0-fpm
fi

docker buildx build --pull -f 56/Dockerfile --platform linux/arm64,linux/amd64 -t phpdockerio/php:5.6-fpm

if [[ ${TAG} != "latest" ]] ; then
  docker tag phpdockerio/php:5.6-fpm
  docker push phpdockerio/php:5.6-fpm
fi

# Tear down build servers
docker buildx rm mavaddat
