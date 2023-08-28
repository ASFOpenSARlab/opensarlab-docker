# RUN as jovyan

# Startup scripts
bash /etc/jupyter-hooks/iris.sh

# Start notebook server
bash /usr/local/bin/start-notebook.sh \
    --LabApp.default_url="/desktop" \
    --
