#!/bin/bash

set -e

REGISTRY=docker.io
UNAME=overtone1000
IMAGE_NAME=nginx
TAG=latest

FULLTAG=$REGISTRY/$UNAME/$IMAGE_NAME:$TAG

sudo docker login -u "$UNAME" $REGISTRY
#sudo docker build -t $TAG ./build
sudo docker image tag $IMAGE_NAME:$TAG $FULLTAG
sudo docker push $FULLTAG