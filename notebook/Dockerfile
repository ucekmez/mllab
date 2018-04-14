FROM nvidia/cuda:9.0-base-ubuntu16.04

MAINTAINER Ugur Cekmez <ugur.cekmez@tubitak.gov.tr>

# set NVIDIA ML repo
RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

# install system-wide packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-9-0 \
        cuda-cublas-dev-9-0 \
        cuda-cudart-dev-9-0 \
        cuda-cufft-dev-9-0 \
        cuda-curand-dev-9-0 \
        cuda-cusolver-dev-9-0 \
        cuda-cusparse-dev-9-0 \
        curl \
        wget \
        vim \
        cmake \
        g++ \
        git \
        ca-certificates \
        libcudnn7=7.0.5.15-1+cuda9.0 \
        libcudnn7-dev=7.0.5.15-1+cuda9.0 \
        libcurl3-dev \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        libjpeg-dev \
        python-setuptools \
        python3.5 \
        python3.5-dev \
        python3-setuptools \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        wget \
        && \
    rm -rf /var/lib/apt/lists/* && \
    find /usr/local/cuda-9.0/lib64/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete && \
    rm /usr/lib/x86_64-linux-gnu/libcudnn_static_v7.a

# make python3 default
RUN ln -s -f /usr/bin/python3 /usr/bin/python

# install pip
RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
rm get-pip.py

# install dev packages from requirements.txt
COPY requirements.txt requirements.txt
RUN pip install --no-cache -r requirements.txt --upgrade # python3

################################### install tensorflow gpu
#Running bazel inside a `docker build` command causes trouble, cf:
# https://github.com/bazelbuild/bazel/issues/134
# The easiest solution is to set up a bazelrc file forcing --batch.
RUN echo "startup --batch" >>/etc/bazel.bazelrc
# Similarly, we need to workaround sandboxing issues:
# https://github.com/bazelbuild/bazel/issues/418
RUN echo "build --spawn_strategy=standalone --genrule_strategy=standalone" \
  >>/etc/bazel.bazelrc
# Install the most recent bazel release.
ENV BAZEL_VERSION 0.11.0
WORKDIR /
RUN mkdir /bazel && \
  cd /bazel && \
  curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
  curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE && \
  chmod +x bazel-*.sh && \
  ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
  cd / && \
  rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# Download and build TensorFlow.
WORKDIR /tensorflow
RUN git clone --branch=r1.7 --depth=1 https://github.com/tensorflow/tensorflow.git .

# Configure the build for our CUDA configuration.
ENV CI_BUILD_PYTHON python
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV TF_NEED_CUDA 1
ENV TF_CUDA_COMPUTE_CAPABILITIES=3.0,3.5,5.2,6.0,6.1,7.0
ENV TF_CUDA_VERSION=9.0
ENV TF_CUDNN_VERSION=7

RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
  LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs:${LD_LIBRARY_PATH} \
  tensorflow/tools/ci_build/builds/configured GPU \
  bazel build -c opt --config=cuda \
	--cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
      tensorflow/tools/pip_package:build_pip_package && \
  rm /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
  bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/pip && \
  pip --no-cache-dir install --upgrade /tmp/pip/tensorflow-*.whl && \
  rm -rf /tmp/pip && \
  rm -rf /root/.cache
# Clean up pip wheel and Bazel cache when done.

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
################################### /install tensorflow gpu

# Install latest nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y --no-install-recommends \
  nodejs       \
  build-essential
RUN npm install -g configurable-http-proxy # for jupyterhub

# Install OpenSSH to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
  mkdir -p /var/run/sshd


# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
  echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
  mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# pytorch requires a custom step
RUN pip install http://download.pytorch.org/whl/cu91/torch-0.3.1-cp35-cp35m-linux_x86_64.whl


### Install some jupyter lab extensions
# TODO: does not work
# latex extension : https://github.com/jupyterlab/jupyterlab-latex
# RUN jupyter labextension install @jupyterlab/latex

# bokeh extension : https://github.com/bokeh/jupyterlab_bokeh
RUN jupyter labextension install jupyterlab_bokeh

# github extension : https://github.com/jupyterlab/jupyterlab-github
RUN jupyter labextension install @jupyterlab/github

# drawio extension : https://github.com/QuantStack/jupyterlab-drawio
RUN jupyter labextension install jupyterlab-drawio


# change workspace
RUN mkdir /workspace
WORKDIR /workspace

# create an examples dir into workspace
RUN mkdir examples

# move examples
COPY keras_imdb_lstm.ipynb examples/keras_imdb_lstm.ipynb
COPY keras_mnist_cnn_example.ipynb examples/keras_mnist_cnn_example.ipynb
COPY install_3rd_party_example.ipynb examples/install_3rd_party_example.ipynb

# run notebook
ENTRYPOINT ["jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--port=8888", "--allow-root"]

# EOF
