#!/bin/bash
IMAGE_NAME=payara:4.1.152.1.openjdk8

docker build -t $IMAGE_NAME .

if [ $? -ne 0 ]
then
    echo "Build failed!"
else
    echo "Payara 4.1.152.1 docker image has been built."
    echo "To start a new container, execute: docker run -i -P -t payara:4.1.152.1.openjdk8  /bin/bash "
fi


