# setup base
FROM ucekmez/mlbase
FROM tensorflow/tensorflow:latest-gpu
MAINTAINER Ugur Cekmez <ugur.cekmez@tubitak.gov.tr>

# change workspace
RUN mkdir /workspace
WORKDIR /workspace
RUN mkdir examples

# move examples
COPY keras_imdb_lstm.ipynb examples/keras_imdb_lstm.ipynb
COPY keras_mnist_cnn_example.ipynb examples/keras_mnist_cnn_example.ipynb
COPY install_3rd_party_example.ipynb examples/install_3rd_party_example.ipynb

# run notebook
ENTRYPOINT ["jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--port=8888", "--allow-root"]


# EOF
