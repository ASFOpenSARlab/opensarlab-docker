#!/usr/bin/env bash

# GEOS627 - inverse

set -ex

pip install --user \
    nbgitpuller \
    ipywidgets \
    mpldatacursor \
    rise \
    hide_code \
    jupyter_nbextensions_configurator

# copy over our version of pull.py
# REMINDER: REMOVE IF CHANGES ARE MERGED TO NBGITPULLER
python=$(python --version 2>&1)
v=$(echo $python | cut -d'.' -f 2)
cp "${INVERSE_FILES}"/pull.py /home/jovyan/.local/lib/python3."$v"/site-packages/nbgitpuller/pull.py

# cp "${INVERSE_FILES}"/install_unavco_pkgs.sh /home/jovyan/.local/install_unavco_pkgs.sh

# Install and enable nbextensions
jupyter serverextension enable --py nbgitpuller
jupyter nbextensions_configurator enable --user
jupyter nbextension enable --py widgetsnbextension --user
jupyter-nbextension enable rise --py --user
jupyter nbextension install --py hide_code --user
jupyter nbextension enable --py hide_code --user
jupyter serverextension enable --py hide_code --user

# Copy custom jupyter magic command, df (displays available disc space on volume)
mkdir -p $HOME/.ipython/image_default/startup/
cp "${INVERSE_FILES}"/00-df.py $HOME/.ipython/image_default/startup/00-df.py

# Pull in any repos you would like cloned to user volumes
gitpuller https://github.com/parosen/Geo-SInC.git main $HOME/Geo-SInC

CONDARC=$HOME/.condarc
if ! test -f "$CONDARC"; then
cat <<EOT >> $CONDARC
channels:
  - conda-forge
  - defaults
channel_priority: strict
create_default_packages:
  - jupyter
  - kernda
envs_dirs:
  - /home/jovyan/.local/envs
  - /opt/conda/envs
EOT
fi

conda init

mkdir -p "$HOME"/.local/envs/

LOCAL="$HOME"/.local
ENVS="$LOCAL"/envs
# NAME=unavco
NAME=inverse
PREFIX="$ENVS"/"$NAME"
SITE_PACKAGES=$PREFIX"/lib/python3.8/site-packages"

# where .yml file will be read
if [ ! -d "$PREFIX" ]; then
  conda env create -f "$ENVS"/"$NAME".yml
else
  conda env update -f "$ENVS"/"$NAME".yml
fi

conda run -n "$NAME" kernda --display-name "$NAME" -o --env-dir "$PREFIX" "$PREFIX"/share/jupyter/kernels/python3/kernel.json

conda clean -p -t --yes

JN_CONFIG=$HOME/.jupyter/jupyter_notebook_config.json
if ! grep -q "\"CondaKernelSpecManager\":" "$JN_CONFIG"; then
jq '. += {"CondaKernelSpecManager": {"name_format": "{display_name}", "env_filter": ".*opt/conda.*"}}' "$JN_CONFIG" >> temp;
mv temp "$JN_CONFIG";
fi

# source ~/.local/install_unavco_pkgs.sh

BASH_RC=/home/jovyan/.bashrc
# grep -qxF 'conda activate unavco' $BASH_RC || echo 'conda activate unavco' >> $BASH_RC
grep -qxF 'conda activate inverse' $BASH_RC || echo 'conda activate inverse' >> $BASH_RC

BASH_PROFILE=$HOME/.bash_profile
if ! test -f "$BASH_PROFILE"; then
cat <<EOT >> $BASH_PROFILE
if [ -s ~/.bashrc ]; then
    source ~/.bashrc;
fi
EOT
fi
