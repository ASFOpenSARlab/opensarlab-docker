#!/bin/bash

set -ex

docker build -f dockerfile -t unavco:latest .

docker run -it --rm -p 8888:8888 -v $(pwd)/home:/home/jovyan unavco:latest