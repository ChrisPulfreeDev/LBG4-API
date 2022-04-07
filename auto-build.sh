#!/bin/bash
# ask which port should be used tom access app from web browser (external)
let vmPort=$1
let containerPort=$2
if [$vmPort -eq ""]
then 
	vmPort=8080
fi
if [$containerPort -eq ""]
then
	containerPort=8080
fi
echo $vmPort
echo $containerPort 
# go to image directory
cd ~/LBG4-API
# output list of running containers to the console 
echo "*** docker containers running before build ***"
docker ps
# stop container (in case it's already running)
echo "*** stop mea-app-c1 container ***" 
docker stop mea-app-c1
# remove mea-project image
echo "*** remove image ***"
docker rm mea-app-c1
docker rmi mea-project:v2
# test app
echo "*** test app ***"
npm install
npm test
# build mea-image
# docker build -t mea-project .          # this was Sprint 1 & 2 build command - replaced by V2 build below
echo "*** build image ***"
docker build -t mea-project:v2 .
# push to GCR (added in Sprint 3 step 3 of project).
echo "*** push to GCR ***" 
docker tag mea-project:v2 gcr.io/lbg-210322/mea-project:v2
docker push gcr.io/lbg-210322/mea-project:v2
# run image in container (note --env PORT will override Dockerfile ENV PORT=5000)
echo "*** docker run ***"
docker run --name mea-app-c1 --rm -d -p$vmPort:$containerPort --env PORT=$containerPort mea-project:v2
# show running iamges (should include mea-app-c1 on port entered
echo "*** active docker containers ***"
docker ps
