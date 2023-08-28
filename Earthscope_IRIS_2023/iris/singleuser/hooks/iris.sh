#!/bin/bash
set -ve

HOME=/home/jovyan

# Add Path to local pip execs.
export PATH=$HOME/.local/bin:$PATH

# Disable the extension manager in Jupyterlab since server extensions are uninstallable
# by users and non-server extension installs do not persist over server restarts
jupyter labextension disable @jupyterlab/extensionmanager-extension

mkdir -p $HOME/.ipython/profile_default/startup/
cp /etc/jupyter-hooks/custom_magics/00-df.py $HOME/.ipython/profile_default/startup/00-df.py

CONDARC=$HOME/.condarc
if ! test -f "$CONDARC"; then
cat <<EOT >> $CONDARC
channels:
  - conda-forge
  - defaults

channel_priority: strict

envs_dirs:
  - /home/jovyan/.local/envs
  - /opt/conda/envs
EOT
fi

KERNELS=$HOME/.local/share/jupyter/kernels
OLD_KERNELS=$HOME/.local/share/jupyter/kernels_old
FLAG=$HOME/.jupyter/old_kernels_flag.txt
if ! test -f "$FLAG" && test -d "$KERNELS"; then
cp /etc/jupyter-hooks/etc/old_kernels_flag.txt $HOME/.jupyter/old_kernels_flag.txt
mv $KERNELS $OLD_KERNELS
cp /etc/jupyter-hooks/etc/kernels_rename_README $OLD_KERNELS/kernels_rename_README
fi

# Add a CondaKernelSpecManager section to jupyter_notebook_config.json to display nicely formatted kernel names
JUPYTER=$HOME/.jupyter
mkdir -p "$JUPYTER"

JN_CONFIG=$JUPYTER/jupyter_notebook_config.json
if [ ! -f "$JN_CONFIG" ]; then
echo '{}' > "$JN_CONFIG"
fi

if ! grep -q "\"CondaKernelSpecManager\":" "$JN_CONFIG"; then
jq '. += {"CondaKernelSpecManager": {"name_format": "{display_name}"}}' "$JN_CONFIG" >> temp;
mv temp "$JN_CONFIG";
fi

if ! grep -q "\"NotebookApp\":" "$JN_CONFIG"; then
jq '. += {"NotebookApp": {"default_url": "/desktop", "terminado_settings": {"shell_command": ["/bin/tcsh"]}}}' "$JN_CONFIG" >> temp;
mv temp "$JN_CONFIG";
fi

conda init bash
conda init tcsh

BASH_PROFILE=$HOME/.bash_profile
if ! test -f "$BASH_PROFILE"; then
cat <<EOT >> $BASH_PROFILE
if [ -s ~/.bashrc ]; then
    source ~/.bashrc;
fi
EOT
fi

BASHRC=$HOME/.bashrc
if ! grep -q "conda activate iris" "$BASHRC"; then
cat <<EOT >> $BASHRC
conda config --set auto_activate_base false
conda activate iris
EOT
fi

if ! grep -q "alias python3=python" "$BASHRC"; then
cat <<EOT >> $BASHRC
alias python3=python
EOT
fi

TCSHRC=$HOME/.tcshrc
if ! grep -q "conda activate iris" "$TCSHRC"; then
cat <<EOT >> $TCSHRC
conda config --set auto_activate_base false
conda activate iris
EOT
fi

if ! grep -q "alias python3 python" "$TCSHRC"; then
cat <<EOT >> $TCSHRC
alias python3 python
EOT
fi

if ! grep -q "set noclobber" "$TCSHRC"; then
cat <<EOT >> $TCSHRC
set noclobber
EOT
fi

aws --region=us-west-2 --no-sign-request s3 cp s3://asf-jupyter-data-west/IRIS/SSBWFiles.zip /home/jovyan/iris_data/SSBWFiles.zip
unzip -o /home/jovyan/iris_data/SSBWFiles.zip -d /home/jovyan/iris_data
rm /home/jovyan/iris_data/SSBWFiles.zip
