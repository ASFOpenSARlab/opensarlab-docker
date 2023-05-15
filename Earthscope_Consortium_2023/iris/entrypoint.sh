#! /usr/bin/env bash
# RUN AS ROOT

# Change permissions of /home/jovyan to jovyan:users
chown -R 1000:100 /home/jovyan

# Run as jovyan
# https://stackoverflow.com/a/39398511
exec runuser -u jovyan "$@"
