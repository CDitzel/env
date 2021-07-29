#:push hub.docker.com/sewing31/naja:latest
ARG BASE_CUDA_VERSION=10.1
# FROM nvcr.io/nvidia/pytorch:20.09-py3
# FROM nvcr.io/nvidia/cuda:${BASE_CUDA_VERSION}-cudnn7-devel-ubuntu18.04
# FROM python:3.8-slim-buster
FROM pytorch/pytorch:1.8.0-cuda11.1-cudnn8-devel
MAINTAINER Carsten Ditzel <carsten.ditzel@uni-ulm.de>

# use a single RUN, deleting files inside the install-packages script will
# ensure packages never make it into any layer of the image, wasting any space.
COPY install-packages.sh .
RUN ./install-packages.sh

ENV DISPLAY=:99
USER $NB_UID

# only for using venv within Docker container
# ENV VIRTUAL_ENV=/opt/venv
# Use python version of parent Docker image
# RUN python3 -m venv $VIRTUAL_ENV
# RUN $VIRTUAL_ENV/bin/pip3 install --upgrade pip
# Activating a virtualenv is nothing else but prepending it to the path
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"
#The virtualenv now automatically works for subsequent RUN and CMD stateements

RUN pip3 install numpy setuptools wheel vtk

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r ./requirements.txt

#RUN ln -s /usr/bin/python3 /usr/bin/python
#COPY src/ /app

# WORKDIR /app # defines where in the container in which you enter and execute commands
# EXPOSE 8888 # expose port, it is through this port that we communicate with our container

# just for keeping the container running
#CMD tail -f /dev/null

ADD docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Add an x-server to the entrypoint. This is needed by Mayavi
#ENTRYPOINT ["/tini", "-g", "--", "xvfb-run"]
