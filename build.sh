#!/bin/bash

set -e

TAG=hub.docker.com:5000/overtone1000/nginx:latest

sudo docker build -t $TAG ./build
sudo docker push $TAG