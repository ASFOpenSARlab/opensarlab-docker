FROM jupyter/base-notebook:lab-4.0.7 as release

# Base Stage ****************************************************************
USER root
WORKDIR /

RUN set -ve

RUN apt update
RUN apt install --no-install-recommends -y \
        software-properties-common \
        git && \
    apt-get install -y gpg-agent && \
    add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
    apt update && \
    apt upgrade -y

RUN apt install --no-install-recommends --fix-missing -y \
    ### GENERAL
    zip \
    unzip \
    wget \
    vim \
    rsync \
    less \
    snaphu \
    curl \
    openssh-client \
    libgl1-mesa-glx \
    emacs \
    gnupg2 \
    jq \
    gfortran \
    make \
    ## Image stuff
    proj-bin \
    geotiff-bin \
    libshp-dev \
    libshp2 \
    libhdf5-dev \
    libnetcdf-dev \
    libgdal-dev \
    libgsl-dev \
    gdal-bin \
    ### SNAP
    default-jdk-headless \
    ### Install texlive for PDF exporting of notebooks containing LaTex
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    ### PyGMTSAR
    csh \
    autoconf \
    make \ 
    libtiff5-dev \ 
    liblapack-dev \
    libgmt-dev \
    gmt-dcw \
    gmt-gshhg \
    gmt \
    gedit \
    nano \
    --

# Update conda and mamba: this breaks things in the hook, need to play with it more
# Updating just conda and mamba will auto-remove pip, so force pip to update to remain
#RUN mamba update -c conda-forge -y conda mamba pip

RUN mamba install -c conda-forge -y \
    ### Install plotting and general
    awscli \
    boto3 \
    pyyaml \
    bokeh \
    plotly \
    'pyopenssl>=23.0.0' \
    zstd==1.5.5 \
    zstandard==0.21.0 \
    ### Install jupyter libaries
    kernda \
    jupyter-resource-usage \
    nb_conda_kernels \
    jupyterlab-spellchecker \
    ipympl \
    jupyterlab_widgets \
    ipywidgets \
    #jupyter-ai \
    jupyterlab-git \
    panel \
    ### Dask
    dask-gateway \
    dask \
    distributed \
    --

RUN python3 -m pip install \
        ### For ASF
        url-widget \
        ##opensarlab-frontend==1.5.1 \
        jupyterlab-jupyterbook-navigation==0.1.4 \
        ### For pyGMTSAR
        pygmtsar &&\
    cd / &&\
        mkdir -p /tmp/build/GMTSAR /usr/local/GMTSAR &&\
        git clone --branch master https://github.com/gmtsar/gmtsar /tmp/build/GMTSAR/ &&\
        cd /tmp/build/GMTSAR &&\
        autoconf &&\
        ./configure --with-orbits-dir=/tmp CFLAGS='-z muldefs' LDFLAGS='-z muldefs' &&\
        make &&\
        make install &&\
        mv -v /tmp/build/GMTSAR/bin /usr/local/GMTSAR/bin &&\
        rm -rf /tmp/build &&\
    cd / &&\
    ### Extra stuff
    # Make sure that any files in the home directory are jovyan permission
    chown -R jovyan:users $HOME/ &&\
    # Make sure mamba (within conda) has write access
    chmod -R 777 /opt/conda/pkgs/ &&\
    # Make sure JupyterLab settings is writable
    mkdir -p /opt/conda/share/jupyter/lab/settings/ &&\
    chown jovyan:users /opt/conda/share/jupyter/lab/settings/ &&\
    chmod -R 775 /opt/conda/share/jupyter/lab/settings/ &&\
    # Add sudo group user 599 elevation
    addgroup -gid 599 elevation &&\
    echo '%elevation ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers &&\
    # Use the kernel display name `base` for the base conda environment
    mamba run -n base kernda --display-name base -o /opt/conda/share/jupyter/kernels/python3/kernel.json &&\
    mamba clean -y --all &&\
    mamba init &&\
    rm -rf /home/jovyan/..?* /home/jovyan/.[!.]* /home/jovyan/*

### GMTSAR
ENV PATH=/usr/local/GMTSAR/bin:$PATH

# Addtional built-in environment
COPY env /etc/env
RUN chmod -R 755 /etc/env && \
    chown -R jovyan:users /etc/env

RUN mkdir /aria

RUN wget https://raw.githubusercontent.com/ASFOpenSARlab/opensarlab-envs/main/Environment_Configs/earthscope_insar_env.yml -P /etc/env/ && \
    mv /etc/env/earthscope_insar_env.yml /etc/env/earthscope_insar.yaml && \
    mamba env create -f /etc/env/earthscope_insar.yaml && \
    mamba run -n earthscope_insar kernda -o --display-name earthscope_insar /opt/conda/envs/earthscope_insar/share/jupyter/kernels/python3/kernel.json && \
    source /etc/env/earthscope_insar_env.sh && \
    mamba clean --yes --all && \
    chmod -R 755 /opt/conda/envs && \
    chown -R jovyan:users /opt/conda/envs


# Copy singleuser files
COPY singleuser /etc/singleuser
RUN chmod -R 777 /etc/singleuser

# Copy entrypoint and cmd 
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
COPY --chown=1000:100 cmd.sh /cmd.sh
RUN chmod 755 /cmd.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]

WORKDIR /home/jovyan

FROM release as testing 

COPY ./tests /tests
RUN bash /tests/earthscope_insar.sh
