FROM ubuntu:14.04
MAINTAINER ugur cekmez <ugur.cekmez@tubitak.gov.tr>
RUN apt-get update

RUN apt-get install -y git-core

# install torch
RUN git clone https://github.com/torch/distro.git /root/torch --recursive
WORKDIR /root/torch
RUN ./install-deps
RUN ./install.sh
RUN /bin/bash -c "source /root/.bashrc"
RUN /bin/bash -c "chmod +x /root/torch/install/bin/th"

ENV CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda

WORKDIR /

# install dependencies
RUN /root/torch/install/bin/luarocks install torch
RUN /root/torch/install/bin/luarocks install nn
RUN /root/torch/install/bin/luarocks install image
RUN /root/torch/install/bin/luarocks install lua-cjson
RUN /root/torch/install/bin/luarocks install https://raw.githubusercontent.com/qassemoquab/stnbhwd/master/stnbhwd-scm-1.rockspec
RUN /root/torch/install/bin/luarocks install https://raw.githubusercontent.com/jcjohnson/torch-rnn/master/torch-rnn-scm-1.rockspec
RUN /root/torch/install/bin/luarocks install cutorch
RUN /root/torch/install/bin/luarocks install cunn
RUN /root/torch/install/bin/luarocks install cudnn

RUN git clone https://github.com/jcjohnson/densecap.git

WORKDIR /densecap
RUN mkdir data
RUN mkdir data/models
RUN mkdir data/models/densecap

COPY ./run.sh /densecap
COPY ./densecap-pretrained-vgg16.t7 /densecap/data/models/densecap

#ENTRYPOINT ["/root/torch/install/bin/th", "run_model.lua", "-input_image"]
ENTRYPOINT ["./run.sh"]
