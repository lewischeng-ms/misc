#!/bin/bash

docker build -t my-sample-app .
docker run -it --name my-sample-app -p 3000:3000 my-sample-app
docker rm -f my-sample-app