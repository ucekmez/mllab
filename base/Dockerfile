# setup base
FROM ubuntu:16.04
MAINTAINER Ugur Cekmez <ugur.cekmez@tubitak.gov.tr>

RUN apt-get update

RUN apt-get install -y python3 python3-pip
RUN apt-get install -y git-core
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
RUN npm install -g configurable-http-proxy # for jupyterhub

# install dev packages from requirements.txt
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache -r requirements.txt --upgrade

# pytorch requires a custom step
RUN pip3 install http://download.pytorch.org/whl/cu91/torch-0.3.1-cp35-cp35m-linux_x86_64.whl

# TODO: does not work
# latex extension : https://github.com/jupyterlab/jupyterlab-latex
# RUN jupyter labextension install @jupyterlab/latex

# bokeh extension : https://github.com/bokeh/jupyterlab_bokeh
RUN jupyter labextension install jupyterlab_bokeh

# github extension : https://github.com/jupyterlab/jupyterlab-github
RUN jupyter labextension install @jupyterlab/github

# drawio extension : https://github.com/QuantStack/jupyterlab-drawio
RUN jupyter labextension install jupyterlab-drawio

# EOF
