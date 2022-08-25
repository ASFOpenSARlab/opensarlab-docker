#!/bin/bash

set -ex

docker run -it --init --rm -p 8888:8888 -v $(pwd)/iris_home:/home/jovyan iris2022:latest
