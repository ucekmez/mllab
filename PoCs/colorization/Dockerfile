FROM ubuntu:14.04
MAINTAINER ugur cekmez <ugur.cekmez@tubitak.gov.tr>
RUN apt-get update

RUN apt-get install -y git-core

RUN mkdir /model
COPY ./download_model.sh /model
COPY ./colornet.t7 /model
COPY ./colorize.lua /model
COPY ./run.sh model
WORKDIR /model

# install torch
RUN git clone https://github.com/torch/distro.git /root/torch --recursive
WORKDIR /root/torch
RUN ./install-deps
RUN ./install.sh
RUN /bin/bash -c "source /root/.bashrc"
RUN /bin/bash -c "chmod +x /root/torch/install/bin/th"


WORKDIR /model

# ENTRYPOINT ["/root/torch/install/bin/th", "colorize.lua"]
ENTRYPOINT ["./run.sh"]
