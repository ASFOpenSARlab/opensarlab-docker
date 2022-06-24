#!/bin/bash

set -ex

# docker build -f dockerfile -t geos639:latest .

docker run -it --rm -p 8888:8888 -v $(pwd)/home:/home/jovyan geos639:latest