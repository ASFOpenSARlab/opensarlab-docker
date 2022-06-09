#!/bin/bash
set -e

env="insar_analysis"
env_prefix="/opt/conda/envs/$env"
site_packages=$env_prefix"/lib/python3.8/site-packages"

######## ISCE ########

# start building local path and pythonpath variables
pythonpath=$site_packages/isce:$PYTHONPATH
path=$site_packages/isce/applications:$env_prefix/bin:$PATH

# set ISCE_HOME
conda env config vars set -n $env ISCE_HOME=$site_packages/isce

######## ARIA-Tools ########

# clone the ARIA-Tools repo and build ARIA-Tools
aria="/usr/local/ARIA-tools"
if [ ! -d $aria ]
then
    git clone -b release-v1.1.2 https://github.com/aria-tools/ARIA-tools.git $aria
    wd=$(pwd)
    cd $aria
    conda run python $aria/setup.py build
    conda run python $aria/setup.py install
    cd $wd
fi

path="$aria/tools/bin:$aria/tools/ARIAtools:$path"
pythonpath="$aria/tools:$aria/tools/ARIAtools:$pythonpath"
conda env config vars set -n $env GDAL_HTTP_COOKIEFILE=/tmp/cookies.txt
conda env config vars set -n $env GDAL_HTTP_COOKIEJAR=/tmp/cookies.txt
conda env config vars set -n $env VSI_CACHE=YES

# set PATH and PYTHONPATH
conda env config vars set -n $env PYTHONPATH=$pythonpath
conda env config vars set -n $env PATH=$path