#!/bin/bash

set -e

REGISTRY=docker.io
UNAME=overtone1000
IMAGE_NAME=nginx_certbot
TAG="$1"

FULLTAG=$REGISTRY/$UNAME/$IMAGE_NAME:$TAG

if [ -z $TAG ]; then 
    echo "Please provide the tag as an argument."
    exit 1
else
    echo "Pushing to $FULLTAG"
fi

#podman context use default

#echo "Enter docker password for user $UNAME"
#podman login docker.io
podman build -t $IMAGE_NAME:$TAG ./build
podman image tag $IMAGE_NAME:$TAG $FULLTAG
podman push $FULLTAG