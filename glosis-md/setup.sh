#!/bin/bash
# https://docs.pycsw.org/en/latest/docker.html
# https://github.com/geopython/pycsw/blob/master/docker/compose/docker-compose.scale.yml


cd ~/Work/Code/FAO/GloSIS/glosis-md
mkdir records
cp /home/carva014/Downloads/FAO/SIS/PH/Processed/*.xml /home/carva014/Work/Code/FAO/GloSIS/glosis-md/records
docker compose up
# http://localhost:8001/

