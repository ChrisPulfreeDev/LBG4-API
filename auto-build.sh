#!/bin/bash
# ask which port should be used tom access app from web browser (external)
echo "Which Port should be used from web browser (8080 is default):"
read VMPORT
# ask which port should be used internally by the conatiner
echo "Which Port should the conatainer run on (8080 is default):"
read CONTAINERPORT
# go to image directory
cd ~/LBG4-API
# output list of running containers to the console 
docker ps
# stop container (in case it's already running) 
docker stop mea-app-c1
# remove mea-project image
docker rm mea-app-c1
docker rmi mea-project
# test app
npm install
npm test
# build mea-image
docker build -t mea-project .
# run image in container (note --env PORT will override Dockerfile ENV PORT=5000)
docker run --name mea-app-c1 --rm -d -p$VMPORT:$CONTAINERPORT --env PORT=$CONTAINERPORT mea-project
# show running iamges (should include mea-app-c1 on port entered
docker ps
