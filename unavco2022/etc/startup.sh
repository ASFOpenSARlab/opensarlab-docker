#!/usr/bin/env bash

set -ex

python -m pip install --user \
    ipywidgets \
    mpldatacursor \
    nbgitpuller

python=$(python --version 2>&1)
v=$(echo $python | cut -d'.' -f 2)

# Add Path to local pip execs.
export PATH=$HOME/.local/bin:$PATH

####################################################
# Disable the extension manager in Jupyterlab since server extensions are uninstallable
# by users and non-server extension installs do not persist over server restarts
jupyter labextension disable @jupyterlab/extensionmanager-extension

mkdir -p $HOME/.ipython/profile_default/startup/

gitpuller https://github.com/parosen/Geo-SInC.git main $HOME/Geo-SInC
gitpuller https://github.com/ASFOpenSARlab/opensarlab-envs.git main $HOME/conda_environments

####################################################

python -m pip install df-jupyter-magic

if [ ! -f "$HOME/.jupyter/jupyter_lab_config.py" ]; then
cat <<EOT > "$HOME"/.jupyter/jupyter_lab_config.py
c.InteractiveShellApp.extensions = ['df_jupyter_magic']
c.NotebookApp.kernel_manager_class = ['notebook.services.kernels.kernelmanager.AsyncMappingKernelManager']
EOT
fi