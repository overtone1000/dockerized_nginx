#!/bin/bash

set -e

REGISTRY=docker.io
UNAME=overtone1000
IMAGE_NAME=nginx
TAG=latest

FULLTAG=$REGISTRY/$UNAME/$IMAGE_NAME:$TAG

#echo "Enter docker password for user $UNAME"
#docker login -u $UNAME $REGISTRY
docker build -t $IMAGE_NAME:$TAG ./build
docker image tag $IMAGE_NAME:$TAG $FULLTAG
docker push $FULLTAG