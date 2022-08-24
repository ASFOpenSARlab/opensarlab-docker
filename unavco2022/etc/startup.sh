#!/usr/bin/env bash

set -ex

########################## work but no sync ##########################

# if [ ! -d $HOME/Geo-SInC ];
# then
#   mv -v /etc/unavco/Geo-SInC $HOME
# else
#   rm -rf /etc/unavco/Geo-SInC
# fi

# if [ ! -d $HOME/conda_environments ];
# then
#   mv -v /etc/unavco/conda_environments $HOME
# else
#   rm -rf /etc/unavco/conda_environments
# fi

########################## work but no sync ##########################


# python -m pip install --user \
#     ipywidgets \
#     mpldatacursor

python -m pip install --user \
    ipywidgets \
    mpldatacursor \
    nbgitpuller
    # rise \
    # # hide_code \
    # jupyter_nbextensions_configurator

# # conda install -c conda-forge jupyter_client=7.1.0 jupyter_server=1.13.1  --force-reinstall

python=$(python --version 2>&1)
v=$(echo $python | cut -d'.' -f 2)

# Add Path to local pip execs.
export PATH=$HOME/.local/bin:$PATH

############# pull.py ##############################
python -m pip install --user nbgitpuller

# # copy over our version of pull.py
# # REMINDER: REMOVE IF CHANGES ARE MERGED TO NBGITPULLER
# cp "${UNAVCO_FILES}"/pull.py /home/jovyan/.local/lib/python3.9/site-packages/nbgitpuller/pull.py

# Disable the extension manager in Jupyterlab since server extensions are uninstallable
# by users and non-server extension installs do not persist over server restarts
jupyter labextension disable @jupyterlab/extensionmanager-extension

mkdir -p $HOME/.ipython/profile_default/startup/
# cp "${UNAVCO_FILES}"/00-df.py $HOME/.ipython/profile_default/startup/00-df.py

gitpuller https://github.com/parosen/Geo-SInC.git main $HOME/Geo-SInC
gitpuller https://github.com/ASFOpenSARlab/opensarlab-envs.git main $HOME/conda_environments

####################################################

# # Add Path to local pip execs.
# export PATH=$HOME/.local/bin:$PATH

# CONDARC=$HOME/.condarc
# if ! test -f "$CONDARC"; then
# cat <<EOT >> $CONDARC
# channels:
#   - conda-forge
#   - defaults
# channel_priority: strict
# envs_dirs:
#   - /home/jovyan/.local/envs
#   - /opt/conda/envs
# EOT
# fi

# conda init

# # added unavco
# echo "create directory"
# mkdir -p "$HOME"/.local/envs/

# ############### Copy to .local/envs ###############
# LOCAL="$HOME"/.local
# ENVS="$LOCAL"/envs
# NAME=unavco
# PREFIX="$ENVS"/"$NAME" 
# SITE_PACKAGES=$PREFIX"/lib/python3."$v"/site-packages"
# ##############################################################

# echo "$PREFIX"
# if [ ! -d "$PREFIX" ]; then
#   echo "mamba create"
#   mamba env create -f "$ENVS"/"$NAME".yml -q

#   mamba run -n "$NAME" kernda --display-name "$NAME" -o --env-dir "$PREFIX" "$PREFIX"/share/jupyter/kernels/python3/kernel.json
#   source ${UNAVCO_FILES}/unavco_env.sh
# else
#   echo "mamba update"
#   mamba env update -f "$ENVS"/"$NAME".yml -q
# fi

# # echo "mamba clean"

# # mamba clean --yes --all

# # check if config file exists
# JN_CONFIG=$HOME/.jupyter/jupyter_notebook_config.json

# # generate config file if it doesn't exist
# if [ ! -f "$HOME/.jupyter" ]; then
#   echo "Creating jupyter_notebook_config.json"
#   mkdir -p "$HOME/.jupyter"
#   touch "$JN_CONFIG"
# fi

# if ! grep -q "\"CondaKernelSpecManager\":" "$JN_CONFIG"; then
# jq '. += {"CondaKernelSpecManager": {"name_format": "{display_name}", "env_filter": ".*opt/conda.*"}}' "$JN_CONFIG" >> temp;
# mv temp "$JN_CONFIG";
# fi

# BASH_RC=/home/jovyan/.bashrc
# grep -qxF 'conda activate unavco' $BASH_RC || echo 'conda activate unavco' >> $BASH_RC

# # bash profile has dup in unavco.sh
# BASH_PROFILE=$HOME/.bash_profile
# if ! test -f "$BASH_PROFILE"; then
# cat <<EOT > $BASH_PROFILE
# if [ -s ~/.bashrc ]; then
#     source ~/.bashrc;
# fi
# EOT
# fi

python -m pip install df-jupyter-magic

if [ ! -f "$HOME/.jupyter/jupyter_lab_config.py" ]; then
cat <<EOT > "$HOME"/.jupyter/jupyter_lab_config.py
c.InteractiveShellApp.extensions = ['df_jupyter_magic']
c.NotebookApp.kernel_manager_class = ['notebook.services.kernels.kernelmanager.AsyncMappingKernelManager']
EOT
fi


#############################################################################
# #!/bin/bash
# set -ve

# # python /etc/jupyter-hooks/resource_checks/check_storage.py $1

# # Add Path to local pip execs.
# export PATH=$HOME/.local/bin:$PATH

# python -m pip install --user nbgitpuller

# # copy over our version of pull.py
# # REMINDER: REMOVE IF CHANGES ARE MERGED TO NBGITPULLER
# cp /etc/jupyter-hooks/scripts/pull.py /home/jovyan/.local/lib/python3.9/site-packages/nbgitpuller/pull.py

# # Disable the extension manager in Jupyterlab since server extensions are uninstallable
# # by users and non-server extension installs do not persist over server restarts
# jupyter labextension disable @jupyterlab/extensionmanager-extension

# mkdir -p $HOME/.ipython/profile_default/startup/
# cp /etc/jupyter-hooks/custom_magics/00-df.py $HOME/.ipython/profile_default/startup/00-df.py

# gitpuller https://github.com/parosen/Geo-SInC.git main $HOME/Geo-SInC

# gitpuller https://github.com/ASFOpenSARlab/opensarlab-envs.git main $HOME/conda_environments

# # Update page and tree
# mv /opt/conda/lib/python3.9/site-packages/notebook/templates/tree.html /opt/conda/lib/python3.9/site-packages/notebook/templates/original_tree.html
# cp /etc/jupyter-hooks/templates/tree.html /opt/conda/lib/python3.9/site-packages/notebook/templates/tree.html

# mv /opt/conda/lib/python3.9/site-packages/notebook/templates/page.html /opt/conda/lib/python3.9/site-packages/notebook/templates/original_page.html
# cp /etc/jupyter-hooks/templates/page.html /opt/conda/lib/python3.9/site-packages/notebook/templates/page.html

# CONDARC=$HOME/.condarc
# if ! test -f "$CONDARC"; then
# cat <<EOT >> $CONDARC
# channels:
#   - conda-forge
#   - defaults

# channel_priority: strict

# envs_dirs:
#   - /home/jovyan/.local/envs
#   - /opt/conda/envs
# EOT
# fi

# # Add a CondaKernelSpecManager section to jupyter_notebook_config.json to display nicely formatted kernel names
# JN_CONFIG=$HOME/.jupyter/jupyter_notebook_config.json
# if ! test -f "$JN_CONFIG"; then
# echo '{}' > "$JN_CONFIG"
# fi

# if ! grep -q "\"CondaKernelSpecManager\":" "$JN_CONFIG"; then
# jq '. += {"CondaKernelSpecManager": {"name_format": "{display_name}"}}' "$JN_CONFIG" >> temp;
# mv temp "$JN_CONFIG";
# fi

# conda init

# BASH_PROFILE=$HOME/.bash_profile
# if ! test -f "$BASH_PROFILE"; then
# cat <<EOT>> $BASH_PROFILE
# if [ -s ~/.bashrc ]; then