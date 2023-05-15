#!/bin/bash

set -ex

docker run -it --init --rm -p 8888:8888 -v $(pwd)/virtual_home:/home/jovyan iris2022:latest
