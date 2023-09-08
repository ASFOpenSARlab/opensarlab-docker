#!/bin/bash
set -ex

# /opt/conda/envs/earthscope_insar
############### Copy to .local/envs ###############
CONDA=/opt/conda
NAME=earthscope_insar
PY_VERS=$(conda run -n $NAME python --version | cut -b 8-11)
SITE_PACKAGES="$CONDA/envs/$NAME/lib/python$PY_VERS/site-packages"
##############################################################

PATH="$CONDA/envs/$NAME/bin:$PATH"

#conda run -n "$NAME" kernda --display-name $NAME $LOCAL/envs/$NAME/share/jupyter/kernels/python3/kernel.json -o

pythonpath="$PYTHONPATH"
path="$PATH"

######## Set ISCE env vars ########

# start building local path and pythonpath variables
pythonpath=$SITE_PACKAGES/isce:"$pythonpath"
path="$SITE_PACKAGES"/isce/applications:$path

# set ISCE_HOME
conda env config vars set -n $NAME ISCE_HOME="$SITE_PACKAGES"/isce

######## Install ARIA-Tools ########

# clone the ARIA-Tools repo and build ARIA-Tools
ARIA=/aria
ARIATOOLS="$ARIA/ARIA-tools"
if [ ! -d "$ARIATOOLS" ]
then
    git clone https://github.com/aria-tools/ARIA-tools.git "$ARIATOOLS"
    wd=$(pwd)
    cd "$ARIATOOLS"
    conda run -n $NAME python "$ARIATOOLS"/setup.py build
    conda run -n $NAME python "$ARIATOOLS"/setup.py install
    cd "$wd"
fi

path="$ARIATOOLS/ARIA-tools/tools/bin:$ARIATOOLS/ARIA-tools/tools/ARIAtools:"$path
pythonpath="$ARIATOOLS/ARIA-tools/tools:$ARIATOOLS/ARIA-tools/tools/ARIAtools:"$pythonpath
conda env config vars set -n $NAME GDAL_HTTP_COOKIEFILE=/tmp/cookies.txt
conda env config vars set -n $NAME GDAL_HTTP_COOKIEJAR=/tmp/cookies.txt
conda env config vars set -n $NAME VSI_CACHE=YES

# clone the ARIA-tools-docs repo
ARIADOCS="$ARIA/ARIA-tools-docs"
if [ ! -d $ARIADOCS ]
then
    git clone -b master --depth=1 --single-branch https://github.com/aria-tools/ARIA-tools-docs.git $ARIADOCS
fi

#######################

# set PATH and PYTHONPATH
conda env config vars set -n $NAME PYTHONPATH="$pythonpath"
conda env config vars set -n $NAME PATH="$path"


BASH_PROFILE=$HOME/.bash_profile
if ! test -f "$BASH_PROFILE"; then
cat <<EOT >> $BASH_PROFILE
if [ -s ~/.bashrc ]; then
    source ~/.bashrc;
fi
EOT
fi