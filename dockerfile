FROM jupyter/base-notebook:latest

LABEL organization="Alaska Satellite Facility"
LABEL author="Alex Lewandowski, Rui Kawahara, & Eric Lundell"
LABEL date="2021-08-25"

USER root

RUN apt update && \
    apt install --no-install-recommends -y \
        software-properties-common \
        git && \
    add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
    apt update && \
    apt upgrade -y

RUN apt update && \
    apt install --no-install-recommends -y \
        zip \
        unzip \
        wget \
        vim \
        rsync \
        less \
        snaphu \
        openssh-client \
        libgl1-mesa-glx \
        emacs \
        gnupg2 \
        jq \
        gfortran \
        proj-bin \
        geotiff-bin \
        libshp-dev \
        libshp2 \
        libhdf5-dev \
        libnetcdf-dev \
        libgdal-dev \
        libgsl-dev \
        curl

ENV UNAVCO_FILES /etc/unavco

RUN cp /usr/lib/x86_64-linux-gnu/libgeotiff.so.5 /usr/lib/x86_64-linux-gnu/libgeotiff.so.2 && \
    cp /usr/lib/libgdal.so /usr/lib/libgdal.so.20 && \
    cp /usr/lib/x86_64-linux-gnu/libproj.so.19 /usr/lib/x86_64-linux-gnu/libproj.so.12 && \
    cp /usr/lib/x86_64-linux-gnu/libhdf5_serial.so.103 /usr/lib/x86_64-linux-gnu/libhdf5_serial.so.100 && \
    cp /usr/lib/x86_64-linux-gnu/libnetcdf.so.15 /usr/lib/x86_64-linux-gnu/libnetcdf.so.13 && \
    mkdir $UNAVCO_FILES && \
    conda install -c conda-forge jupyter_contrib_nbextensions \
      jupyter_nbextensions_configurator \
      jupyter-resource-usage conda-pack \
      kernda \
      nb_conda_kernels

#COPY unavco.yml ${UNAVCO_FILES}/unavco.yml
#RUN conda env create -f ${UNAVCO_FILES}/unavco.yml

#RUN conda pack -n "$NAME" -o /opt/conda/envs/unavco.tar.gz && \
#  conda env remove -n unavco && \
RUN chmod -R 777 /etc/unavco/

COPY etc/pull.py ${UNAVCO_FILES}/pull.py
COPY etc/startup.sh ${UNAVCO_FILES}/startup.sh
COPY etc/install_unavco_pkgs.sh ${UNAVCO_FILES}/install_unavco_pkgs.sh
COPY etc/00-df.py ${UNAVCO_FILES}/00-df.py

USER jovyan

EXPOSE 8888

ENTRYPOINT bash ${UNAVCO_FILES}/startup.sh; jupyter notebook --no-browser --allow-root
