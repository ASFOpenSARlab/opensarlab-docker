#!/bin/bash
set -ve

# Get python version
PYTHON_VER=$(python -c "import sys; print(f\"python{sys.version_info.major}.{sys.version_info.minor}\")")

python /etc/singleuser/others/check_storage.py $1

# Add Path to local pip execs.
export PATH=$HOME/.local/bin:$PATH

python /etc/singleuser/hooks/etc/pkg_clean.py

python -m pip install --user nbgitpuller

# copy over our version of pull.py
# REMINDER: REMOVE IF CHANGES ARE MERGED TO NBGITPULLER
cp /etc/singleuser/hooks/etc/pull.py /home/jovyan/.local/lib/$PYTHON_VER/site-packages/nbgitpuller/pull.py

# Disable the extension manager in Jupyterlab since server extensions are uninstallable
# by users and non-server extension installs do not persist over server restarts
jupyter labextension disable @jupyterlab/extensionmanager-extension

jupyter labextension disable @jupyterhub/jupyter-server-proxy

gitpuller https://github.com/ASFOpenSARlab/opensarlab-notebooks.git master $HOME/notebooks

gitpuller https://github.com/parosen/Geo-SInC.git main $HOME/Geo-SInC

gitpuller https://github.com/ASFOpenSARlab/opensarlab_MintPy_Recipe_Book.git main $HOME/Data_Recipe_Jupyter_Books/opensarlab_MintPy_Recipe_Book

gitpuller https://github.com/ASFOpenSARlab/opensarlab_OPERA-RTC-S1_Recipe_Book.git main $HOME/Data_Recipe_Jupyter_Books/opensarlab_OPERA-RTC-S1_Recipe_Book

gitpuller https://github.com/ASFOpenSARlab/opensarlab_OPERA-CSLC_Recipe_Book.git main $HOME/Data_Recipe_Jupyter_Books/opensarlab_OPERA-CSLC_Recipe_Book

gitpuller https://github.com/ASFOpenSARlab/opensarlab-envs.git main $HOME/conda_environments

gitpuller https://github.com/uafgeoteach/GEOS657_MRS main $HOME/GEOS_657_Labs

gitpuller https://github.com/ASFOpenSARlab/opensarlab_NISAR_EA_Workshop_2024_1_Recipe_Book.git main $HOME/Workshop_Jupyter_Books/NISAR_EA_Workshop_2024_1_Recipe_Book

# Update page and tree
#mv /opt/conda/lib/$PYTHON_VER/site-packages/notebook/templates/tree.html /opt/conda/lib/$PYTHON_VER/site-packages/notebook/templates/original_tree.html
#cp /etc/singleuser/templates/tree.html /opt/conda/lib/$PYTHON_VER/site-packages/notebook/templates/tree.html

#mv /opt/conda/lib/$PYTHON_VER/site-packages/notebook/templates/page.html /opt/conda/lib/$PYTHON_VER/site-packages/notebook/templates/original_page.html
#cp /etc/singleuser/templates/page.html /opt/conda/lib/$PYTHON_VER/site-packages/notebook/templates/page.html

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

KERNELS=$HOME/.local/share/jupyter/kernels
OLD_KERNELS=$HOME/.local/share/jupyter/kernels_old
FLAG=$HOME/.jupyter/old_kernels_flag.txt
if ! test -f "$FLAG" && test -d "$KERNELS"; then
cp /etc/singleuser/hooks/etc/old_kernels_flag.txt $HOME/.jupyter/old_kernels_flag.txt
mv $KERNELS $OLD_KERNELS
cp /etc/singleuser/hooks/etc/kernels_rename_README $OLD_KERNELS/kernels_rename_README
fi

# Add a CondaKernelSpecManager section to jupyter_notebook_config.json to display nicely formatted kernel names
JN_CONFIG=$HOME/.jupyter/jupyter_notebook_config.json
if ! test -f "$JN_CONFIG"; then
echo '{}' > "$JN_CONFIG"
fi

if ! grep -q "\"CondaKernelSpecManager\":" "$JN_CONFIG"; then
jq '. += {"CondaKernelSpecManager": {"name_format": "{display_name}"}}' "$JN_CONFIG" >> temp;
mv temp "$JN_CONFIG";
fi

conda init

BASH_PROFILE=$HOME/.bash_profile
if ! test -f "$BASH_PROFILE"; then
cat <<EOT>> $BASH_PROFILE
if [ -s ~/.bashrc ]; then
    source ~/.bashrc;
fi
EOT
fi