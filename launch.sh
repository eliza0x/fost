#!/bin/bash
docker build -t xztaityozx/modelsim .

docker run -ti --rm \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v $PWD:/src \
       xztaityozx/modelsim
