#!/bin/bash

set -ex

docker build -f dockerfile -t geos627:latest .

docker run -it --rm -p 8888:8888 -v $(pwd)/home:/home/jovyan geos627:latest
# docker run -it --rm -p 8888:8888 -v $(pwd)/home:/home/jovyan geos627:latest

# to run:
# bash build_start_geos627_container.sh 2>&1 | tee log